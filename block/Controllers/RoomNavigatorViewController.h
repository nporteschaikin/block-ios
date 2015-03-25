//
//  RoomNavigatorViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RoomNavigatorViewControllerAction) {
    RoomNavigatorViewControllerActionCreateNewRoom,
    RoomNavigatorViewControllerActionSettings
};

@class RoomNavigatorViewController;

@protocol RoomNavigatorControllerDelegate

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                selectedRoomAtIndex:(NSUInteger)index;

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                         openedRoom:(NSDictionary *)room;

- (void)roomNavigatorViewControllerBeganSearch:(RoomNavigatorViewController *)roomNavigatorViewController;

- (void)roomNavigatorViewControllerEndedSearch:(RoomNavigatorViewController *)roomNavigatorViewController;

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigationViewController
                             action:(RoomNavigatorViewControllerAction)action;

@end

@interface RoomNavigatorViewController : UIViewController

@property (strong, nonatomic) id<RoomNavigatorControllerDelegate> theDelegate;
@property (strong, nonatomic) NSDictionary *city;
@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSArray *rooms;

- (void)openSessionRooms;

- (void)openRoomAtIndex:(NSUInteger)index;

- (void)leaveRoomAtIndex:(NSUInteger)index;

@end
