//
//  SocketController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/8/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"

@class SocketController;

@protocol SocketControllerDelegate

- (void)socketConnected:(SocketController *)socketController;

- (void)sessionRoomsSentWithSocketController:(SocketController *)socketController;

- (void)roomJoinedAtIndex:(NSUInteger)index
     withSocketController:(SocketController *)socketController;

- (void)roomLeftAtIndex:(NSUInteger)index
       socketController:(SocketController *)socketController;

- (void)messageSent:(NSDictionary *)message
      inRoomAtIndex:(NSUInteger)index
             byUser:(NSDictionary *)user
   socketController:(SocketController *)socketController;

- (void)messageHistorySent:(NSArray *)messages
             inRoomAtIndex:(NSUInteger)index
          socketController:(SocketController *)socketController;

@end

@interface SocketController : NSObject

@property (strong, nonatomic) id<SocketControllerDelegate> delegate;
@property (strong, nonatomic, readonly) NSDictionary *city;
@property (strong, nonatomic, readonly) NSArray *rooms;
@property (strong, nonatomic, readonly) NSMutableArray *openRooms;
@property (nonatomic, readonly) BOOL isConnected;

- (id)initWithCityID:(NSString *)cityID
      sessionManager:(SessionManager *)sessionManager
            delegate:(id<SocketControllerDelegate>)delegate;

- (void)connect;

- (void)joinRoomAtIndex:(NSUInteger)index;

- (void)leaveRoomAtIndex:(NSUInteger)index;

- (void)sendMessage:(NSString *)message
        roomAtIndex:(NSUInteger)index;

- (void)joinDefaultRoom;

@end
