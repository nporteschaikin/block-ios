//
//  RoomNavigatorViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomsViewController.h"

@class RoomNavigatorViewController;

@protocol RoomNavigatorControllerDelegate

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                selectedRoomAtIndex:(NSUInteger)index;

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                  openedRoomAtIndex:(NSUInteger)index;

@end

@interface RoomNavigatorViewController : UITableViewController

@property (strong, nonatomic) id<RoomNavigatorControllerDelegate> theDelegate;

- (id)initWithCity:(NSDictionary *)city
             rooms:(NSArray *)rooms
         openRooms:(NSMutableArray *)openRooms;

- (void)openSessionRooms;

- (void)openRoomAtIndex:(NSUInteger)index;

- (void)leaveRoomAtIndex:(NSUInteger)index;

@end
