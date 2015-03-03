//
//  RoomsViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketController.h"

@class RoomsViewController;

@protocol RoomsViewControllerDelegate

- (void)roomsViewController:(RoomsViewController *)roomsViewController
    askedToJoinRoomAtIndex:(NSUInteger)index;

- (void)roomsViewController:(RoomsViewController *)roomsViewController
    askedToLeaveRoomAtIndex:(NSUInteger)index;

- (void)roomsViewController:(RoomsViewController *)roomsViewController
         askedToSendMessage:(NSString *)message
              toRoomAtIndex:(NSUInteger)index;

@end

@interface RoomsViewController : UIViewController

@property (strong, nonatomic) id<RoomsViewControllerDelegate> theDelegate;

- (id)initWithCity:(NSDictionary *)city
             rooms:(NSArray *)rooms
         openRooms:(NSArray *)openRooms;

- (void)openSessionRooms;

- (void)openRoomAtIndex:(NSUInteger)index;

- (void)leaveRoomAtIndex:(NSUInteger)index;

- (void)addMessage:(NSDictionary *)message
          fromUser:(NSDictionary *)user
     toRoomAtIndex:(NSUInteger)index;

- (void)addMessages:(NSArray *)messages
      toRoomAtIndex:(NSUInteger)index;

@end
