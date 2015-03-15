//
//  RoomNavigatorViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorTableViewController.h"

@class RoomNavigatorViewController;

@protocol RoomNavigatorControllerDelegate

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                selectedRoomAtIndex:(NSUInteger)index;

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                         openedRoom:(NSDictionary *)room;

- (void)roomNavigatorViewControllerBeganSearch:(RoomNavigatorViewController *)roomNavigatorViewController;

- (void)roomNavigatorViewControllerEndedSearch:(RoomNavigatorViewController *)roomNavigatorViewController;

@end

@interface RoomNavigatorViewController : RoomNavigatorTableViewController

@property (strong, nonatomic) id<RoomNavigatorControllerDelegate> theDelegate;
@property (nonatomic, readonly) BOOL searchIsActive;

- (id)initWithCityID:(NSString *)cityID
                city:(NSDictionary *)city
               rooms:(NSArray *)rooms;

- (void)openSessionRooms;

- (void)openRoomAtIndex:(NSUInteger)index;

- (void)leaveRoomAtIndex:(NSUInteger)index;

@end
