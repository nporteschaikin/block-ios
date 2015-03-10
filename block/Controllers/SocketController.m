//
//  SocketController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/8/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "SocketController.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"
#import "APIManager+Cities.h"
#import "Constants.h"

@interface SocketController () <SocketIODelegate>

@property (nonatomic, readwrite) BOOL isConnected;

@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) SessionManager *sessionManager;
@property (strong, nonatomic) SocketIO *socket;

@property (strong, nonatomic) NSDictionary *city;
@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) NSMutableArray *openRooms;

@end

@implementation SocketController

- (id)initWithCityID:(NSString *)cityID
      sessionManager:(SessionManager *)sessionManager
            delegate:(id<SocketControllerDelegate>)delegate {
    if (self = [super init]) {
        self.cityID = cityID;
        self.sessionManager = sessionManager;
        self.delegate = delegate;
        self.socket = [[SocketIO alloc] initWithDelegate:self];
        self.openRooms = [NSMutableArray array];
        self.isConnected = NO;
    }
    return self;
}

- (void)connect {
    [APIManager getCityByID:self.cityID
                 onComplete:^(NSDictionary *city) {
                     self.city = city;
                     self.rooms = [city objectForKey:@"rooms"];
                     [self.socket connectToHost:IOBaseURL
                                         onPort:0
                                     withParams:@{@"token": self.sessionManager.sessionToken,
                                                  @"city": self.cityID}];
    }];
}

- (void)joinRoomAtIndex:(NSUInteger)index {
    if (self.isConnected) {
        NSNumber *roomID = [self roomIDAtIndex:index];
        [self.socket sendEvent:@"room:join"
                      withData:roomID];
    }
}

- (void)leaveRoomAtIndex:(NSUInteger)index {
    if (self.isConnected) {
        NSNumber *roomID = [self openRoomIDAtIndex:index];
        [self.socket sendEvent:@"room:leave"
                      withData:roomID];
    }
}

- (void)sendMessage:(NSString *)message
        roomAtIndex:(NSUInteger)index {
    if (self.isConnected) {
        NSNumber *roomID = [self openRoomIDAtIndex:index];
        [self.socket sendEvent:@"message:send"
                      withData:@{@"room": roomID,
                                 @"message": message}];
    }
}

- (void)joinDefaultRoom {
    if (self.isConnected) {
        NSNumber *roomID = [self.city objectForKey:@"defaultRoomId"];
        [self.socket sendEvent:@"room:join"
                      withData:roomID];
    }
}

- (NSDictionary *)roomByID:(NSNumber *)roomID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)", [roomID intValue]];
    NSArray *rooms = [self.rooms filteredArrayUsingPredicate:predicate];
    return [rooms firstObject];
}

- (NSDictionary *)openRoomByID:(NSNumber *)roomID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)", [roomID intValue]];
    NSArray *rooms = [self.openRooms filteredArrayUsingPredicate:predicate];
    return [rooms firstObject];
}

- (NSNumber *)roomIDAtIndex:(NSUInteger)index {
    NSDictionary *room = [self.rooms objectAtIndex:index];
    return [room objectForKey:@"id"];
}

- (NSNumber *)openRoomIDAtIndex:(NSUInteger)index {
    NSDictionary *room = [self.openRooms objectAtIndex:index];
    return [room objectForKey:@"id"];
}

- (NSUInteger)roomIndexByID:(NSNumber *)roomID {
    NSDictionary *room = [self roomByID:roomID];
    return [self.rooms indexOfObject:room];
}

- (NSUInteger)openRoomIndexByID:(NSNumber *)roomID {
    NSDictionary *room = [self roomByID:roomID];
    return [self.openRooms indexOfObject:room];
}

#pragma mark SocketIODelegate

- (void)socketIODidConnect:(SocketIO *)socket {
    self.isConnected = YES;
    [self.delegate socketConnected:self];
}

- (void)socketIO:(SocketIO *)socket
 didReceiveEvent:(SocketIOPacket *)packet {
    NSString *name = packet.name;
    NSArray *args = packet.args;
    if ([name isEqualToString:@"session:rooms"]) {
        NSArray *roomIDs = (NSArray *)[args objectAtIndex:0];
        for (NSNumber *roomID in roomIDs) {
            NSDictionary *room = [self roomByID:roomID];
            [self.openRooms addObject:room];
        }
        [self.delegate sessionRoomsSentWithSocketController:self];
        for (NSNumber *roomID in roomIDs) {
            [self.socket sendEvent:@"room:history"
                          withData:roomID];
        }
    } else if ([name isEqualToString:@"room:joined"]) {
        NSNumber *roomID = (NSNumber *)[args objectAtIndex:0];
        NSDictionary *room = [self roomByID:roomID];
        [self.openRooms addObject:room];
        [self.delegate roomJoinedAtIndex:(self.openRooms.count - 1)
                        socketController:self];
        [self.socket sendEvent:@"room:history"
                      withData:roomID];
    } else if ([name isEqualToString:@"room:left"]) {
        NSUInteger index = [self openRoomIndexByID:(NSNumber *)[args objectAtIndex:0]];
        [self.openRooms removeObjectAtIndex:index];
        [self.delegate roomLeftAtIndex:index
                      socketController:self];
    } else if ([name isEqualToString:@"message:sent"]) {
        NSUInteger index = [self openRoomIndexByID:(NSNumber *)[args objectAtIndex:0]];
        [self.delegate messageSent:(NSDictionary *)[args objectAtIndex:1]
                      inRoomAtIndex:index
                            byUser:(NSDictionary *)[args objectAtIndex:2]
                  socketController:self];
    } else if ([name isEqualToString:@"room:history"]) {
        NSUInteger index = [self openRoomIndexByID:(NSNumber *)[args objectAtIndex:0]];
        [self.delegate messageHistorySent:(NSArray *)[args objectAtIndex:1]
                            inRoomAtIndex:index
                         socketController:self];
    }
}

@end
