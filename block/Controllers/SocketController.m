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

@property (nonatomic, readwrite) BOOL isSocketConnected;
@property (nonatomic, readwrite) BOOL wasSocketConnected;

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
        self.isSocketConnected = NO;
    }
    return self;
}

- (void)connect {
    [self connectAPI:^(NSDictionary *city) {
        [self connectSocket];
    }];
}

- (void)reconnect {
    if (self.wasSocketConnected && !self.isSocketConnected) {
        [self connectSocket];
    }
}

- (void)connectAPI:(void(^)(NSDictionary *city))onComplete {
    [APIManager getCityByID:self.cityID
                 onComplete:^(NSDictionary *city) {
                     self.city = city;
                     self.rooms = [city objectForKey:@"rooms"];
                     onComplete(city);
                 }];
}

- (void)connectSocket {
    [self.socket connectToHost:IOBaseURL
                        onPort:0
                    withParams:@{@"token": self.sessionManager.sessionToken,
                                 @"city": self.cityID}];
}

- (void)joinRoomAtIndex:(NSUInteger)index {
    if (self.isSocketConnected) {
        NSString *roomID = [self roomIDAtIndex:index];
        [self.socket sendEvent:@"room:join"
                      withData:roomID];
    }
}

- (void)leaveRoomAtIndex:(NSUInteger)index {
    if (self.isSocketConnected) {
        NSString *roomID = [self openRoomIDAtIndex:index];
        [self.socket sendEvent:@"room:leave"
                      withData:roomID];
    }
}

- (void)requestMessageHistoryAtIndex:(NSUInteger)index {
    if (self.isSocketConnected) {
        NSString *roomID = [self openRoomIDAtIndex:index];
        [self.socket sendEvent:@"room:history"
                      withData:roomID];
    }
}

- (void)sendMessage:(NSString *)message
        roomAtIndex:(NSUInteger)index {
    if (self.isSocketConnected) {
        NSString *roomID = [self openRoomIDAtIndex:index];
        [self.socket sendEvent:@"message:send"
                      withData:@{@"room": roomID,
                                 @"message": message}];
    }
}

- (void)joinFirstRoom {
    if (self.isSocketConnected) {
        NSDictionary *room = [self.rooms firstObject];
        NSString *roomID = [room valueForKey:@"_id"];
        [self.socket sendEvent:@"room:join"
                      withData:roomID];
    }
}

- (NSDictionary *)roomByID:(NSString *)roomID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(_id == %@)", roomID];
    NSArray *rooms = [self.rooms filteredArrayUsingPredicate:predicate];
    return [rooms firstObject];
}

- (NSDictionary *)openRoomByID:(NSString *)roomID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(_id == %@)", roomID];
    NSArray *rooms = [self.openRooms filteredArrayUsingPredicate:predicate];
    return [rooms firstObject];
}

- (NSString *)roomIDAtIndex:(NSUInteger)index {
    NSDictionary *room = [self.rooms objectAtIndex:index];
    return [room objectForKey:@"_id"];
}

- (NSString *)openRoomIDAtIndex:(NSUInteger)index {
    NSDictionary *room = [self.openRooms objectAtIndex:index];
    return [room objectForKey:@"_id"];
}

- (NSUInteger)roomIndexByID:(NSString *)roomID {
    NSDictionary *room = [self roomByID:roomID];
    return [self.rooms indexOfObject:room];
}

- (NSUInteger)openRoomIndexByID:(NSString *)roomID {
    NSDictionary *room = [self openRoomByID:roomID];
    return [self.openRooms indexOfObject:room];
}

#pragma mark SocketIODelegate

- (void)socketIODidConnect:(SocketIO *)socket {
    self.isSocketConnected = YES;
    if (self.wasSocketConnected == YES) {
        [self.delegate socketReconnected:self];
    } else {
        [self.delegate socketConnected:self];
    }
    self.wasSocketConnected = YES;
}

- (void)socketIO:(SocketIO *)socket
 didReceiveEvent:(SocketIOPacket *)packet {
    NSString *name = packet.name;
    NSArray *args = packet.args;
    if ([name isEqualToString:@"session:rooms"]) {
        [self handleSessionRoomsEvent:args];
    } else if ([name isEqualToString:@"room:joined"]) {
        [self handleRoomJoinedEvent:args];
    } else if ([name isEqualToString:@"room:left"]) {
        [self handleRoomLeftEvent:args];
    } else if ([name isEqualToString:@"message:sent"]) {
        [self handleMessageSentEvent:args];
    } else if ([name isEqualToString:@"room:history"]) {
        [self handleRoomHistoryEvent:args];
    }
}

- (void)socketIODidDisconnect:(SocketIO *)socket
        disconnectedWithError:(NSError *)error {
    self.isSocketConnected = NO;
    [self.delegate socketDisconnected:self
                            withError:error];
}

#pragma mark - Event handlers

- (void)handleSessionRoomsEvent:(NSArray *)args {
    NSArray *roomIDs = (NSArray *)[args objectAtIndex:0];
    [self.openRooms removeAllObjects];
    for (NSString *roomID in roomIDs) {
        NSDictionary *room = [self roomByID:roomID];
        [self.openRooms addObject:room];
    }
    [self.delegate sessionRoomsSentWithSocketController:self];
}

- (void)handleRoomJoinedEvent:(NSArray *)args {
    NSString *roomID = (NSString *)[args objectAtIndex:0];
    NSDictionary *room = [self roomByID:roomID];
    [self.openRooms addObject:room];
    [self.delegate roomJoinedAtIndex:(self.openRooms.count - 1)
                    socketController:self];
}

- (void)handleRoomLeftEvent:(NSArray *)args {
    NSUInteger index = [self openRoomIndexByID:(NSString *)[args objectAtIndex:0]];
    [self.openRooms removeObjectAtIndex:index];
    [self.delegate roomLeftAtIndex:index
                  socketController:self];
}

- (void)handleMessageSentEvent:(NSArray *)args {
    NSUInteger index = [self openRoomIndexByID:(NSString *)[args objectAtIndex:0]];
    [self.delegate messageSent:(NSDictionary *)[args objectAtIndex:2]
                        byUser:(NSDictionary *)[args objectAtIndex:1]
                 inRoomAtIndex:index
              socketController:self];
}

- (void)handleRoomHistoryEvent:(NSArray *)args {
    NSUInteger index = [self openRoomIndexByID:(NSString *)[args objectAtIndex:0]];
    [self.delegate messageHistorySent:(NSArray *)[args objectAtIndex:1]
                        inRoomAtIndex:index
                     socketController:self];
}

@end
