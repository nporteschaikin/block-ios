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
@property (strong, nonatomic) NSMutableArray *rooms;

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
        self.rooms = [NSMutableArray array];
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
                     onComplete(city);
                 }];
}

- (void)connectSocket {
    [self.socket connectToHost:IOBaseURL
                        onPort:0
                    withParams:@{@"token": self.sessionManager.sessionToken,
                                 @"city": self.cityID}];
}

- (void)joinRoom:(NSDictionary *)room {
    NSString *roomID = [self roomID:room];
    [self joinRoomWithID:roomID];
}

- (void)joinRoomWithID:(NSString *)roomID {
    if (self.isSocketConnected) {
        [self.socket sendEvent:@"room:join"
                      withData:roomID];
    }
}

- (void)leaveRoomAtIndex:(NSUInteger)index {
    if (self.isSocketConnected) {
        NSString *roomID = [self roomIDAtIndex:index];
        [self.socket sendEvent:@"room:leave"
                      withData:roomID];
    }
}

- (void)requestMessageHistoryAtIndex:(NSUInteger)index {
    if (self.isSocketConnected) {
        NSString *roomID = [self roomIDAtIndex:index];
        [self.socket sendEvent:@"room:history"
                      withData:roomID];
    }
}

- (void)sendMessage:(NSString *)message
        roomAtIndex:(NSUInteger)index {
    if (self.isSocketConnected) {
        NSString *roomID = [self roomIDAtIndex:index];
        [self.socket sendEvent:@"message:send"
                      withData:@{@"room": roomID,
                                 @"message": message}];
    }
}

- (void)joinDefaultRoom {
    if (self.isSocketConnected) {
        NSString *roomID = [self.city objectForKey:@"defaultRoom"];
        [self joinRoomWithID:roomID];
    }
}

- (NSDictionary *)roomByID:(NSString *)roomID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", IOCityIDAttribute, roomID];
    NSArray *rooms = [self.rooms filteredArrayUsingPredicate:predicate];
    return [rooms firstObject];
}

- (NSString *)roomIDAtIndex:(NSUInteger)index {
    NSDictionary *room = [self.rooms objectAtIndex:index];
    return [self roomID:room];
}

- (NSUInteger)roomIndexByID:(NSString *)roomID {
    NSDictionary *room = [self roomByID:roomID];
    return [self.rooms indexOfObject:room];
}

- (NSUInteger)roomIndexByRoom:(NSDictionary *)room {
    NSString *roomID = [self roomID:room];
    return [self roomIndexByID:roomID];
}

- (BOOL)roomExists:(NSDictionary *)room {
    NSString *roomID = [self roomID:room];
    if ([self roomByID:roomID]) return true;
    return false;
}

- (NSString *)roomID:(NSDictionary *)room {
    return [room objectForKey:IORoomIDAttribute];
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
    NSArray *rooms = (NSArray *)[args objectAtIndex:0];
    [self.rooms removeAllObjects];
    for (NSDictionary *room in rooms) {
        [self.rooms addObject:room];
    }
    [self.delegate sessionRoomsSentWithSocketController:self];
}

- (void)handleRoomJoinedEvent:(NSArray *)args {
    NSArray *room = (NSArray *)[args objectAtIndex:0];
    [self.rooms addObject:room];
    [self.delegate roomJoinedAtIndex:(self.rooms.count - 1)
                    socketController:self];
}

- (void)handleRoomLeftEvent:(NSArray *)args {
    NSUInteger index = [self roomIndexByID:(NSString *)[args objectAtIndex:0]];
    [self.rooms removeObjectAtIndex:index];
    [self.delegate roomLeftAtIndex:index
                  socketController:self];
}

- (void)handleMessageSentEvent:(NSArray *)args {
    NSUInteger index = [self roomIndexByID:(NSString *)[args objectAtIndex:0]];
    [self.delegate messageSent:(NSDictionary *)[args objectAtIndex:2]
                        byUser:(NSDictionary *)[args objectAtIndex:1]
                 inRoomAtIndex:index
              socketController:self];
}

- (void)handleRoomHistoryEvent:(NSArray *)args {
    NSUInteger index = [self roomIndexByID:(NSString *)[args objectAtIndex:0]];
    NSDate *lastReadDate = [NSDate dateWithTimeIntervalSince1970:[[args objectAtIndex:2] doubleValue] / 1000];
    [self.delegate messageHistorySent:(NSArray *)[args objectAtIndex:1]
                        inRoomAtIndex:index
                         lastReadDate:lastReadDate
                     socketController:self];
}

@end
