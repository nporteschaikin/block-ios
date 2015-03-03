//
//  RoomsNavigationController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomsViewController.h"

@class RoomsNavigationController;

@protocol RoomsNavigationControllerDelegate

- (void)leftBarButtonTappedInRoomsNavigationController:(RoomsNavigationController *)roomsNavigationController;

- (void)roomsNavigationController:(RoomsNavigationController *)roomsNavigationController
                      messageSent:(NSString *)message
                    inRoomAtIndex:(NSUInteger)index;

- (void)roomsNavigationController:(RoomsNavigationController *)roomsNavigationController
          askedToLeaveRoomAtIndex:(NSUInteger)index;

@end

@interface RoomsNavigationController: UINavigationController

@property (strong, nonatomic) id<RoomsNavigationControllerDelegate> theDelegate;

- (id)initWithRooms:(NSArray *)rooms
          openRooms:(NSMutableArray *)openRooms;

- (void)openSessionRooms;

- (void)openRoomAtIndex:(NSUInteger)index
                   view:(BOOL)pop
               animated:(BOOL)animated;

- (void)leaveRoomAtIndex:(NSUInteger)index;

- (void)viewRoomAtIndex:(NSUInteger)index
               animated:(BOOL)animated;

- (void)addMessages:(NSArray *)messages
      toRoomAtIndex:(NSUInteger)index;

- (void)addMessage:(NSDictionary *)message
          fromUser:(NSDictionary *)user
     toRoomAtIndex:(NSUInteger)index;

@end

