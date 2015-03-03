//
//  SocketViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/8/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "SocketViewController.h"
#import "SocketController.h"
#import "RoomsViewController.h"
#import "MainViewController.h"

@interface SocketViewController () <SocketControllerDelegate, RoomsViewControllerDelegate>

@property (strong, nonatomic) SocketController *socketController;
@property (strong, nonatomic) RoomsViewController *roomsViewController;

@end

@implementation SocketViewController

- (id)initWithCityID:(NSString *)cityID
      sessionManager:(SessionManager *)sessionManager {
    if (self = [super init]) {
        self.socketController = [[SocketController alloc] initWithCityID:cityID
                                                          sessionManager:sessionManager
                                                                delegate:self];
        [self.socketController connect];
    }
    return self;
}

#pragma mark - SocketControllerDelegate

- (void)socketConnected:(SocketController *)socketController {
    self.roomsViewController = [[RoomsViewController alloc] initWithCity:socketController.city
                                                                   rooms:socketController.rooms
                                                               openRooms:socketController.openRooms];
    self.roomsViewController.theDelegate = self;
    [(MainViewController *)self.parentViewController slideToViewController:self.roomsViewController
                                                                  duration:0
                                                                completion:nil];
}

- (void)sessionRoomsSentWithSocketController:(SocketController *)socketController {
    if (socketController.openRooms.count) {
        [self.roomsViewController openSessionRooms];
    } else {
        [socketController joinDefaultRoom];
    }
}

- (void)roomJoinedAtIndex:(NSUInteger)index
     withSocketController:(SocketController *)socketController {
    [self.roomsViewController openRoomAtIndex:index];
}

- (void)roomLeftAtIndex:(NSUInteger)index
       socketController:(SocketController *)socketController {
    [self.roomsViewController leaveRoomAtIndex:index];
}

- (void)messageSent:(NSDictionary *)message
      inRoomAtIndex:(NSUInteger)index
             byUser:(NSDictionary *)user
   socketController:(SocketController *)socketController {
    [self.roomsViewController addMessage:message
                                fromUser:user
                           toRoomAtIndex:index];
}

- (void)messageHistorySent:(NSArray *)messages
             inRoomAtIndex:(NSUInteger)index
          socketController:(SocketController *)socketController {
    [self.roomsViewController addMessages:messages
                            toRoomAtIndex:index];
}

#pragma mark - RoomsViewControllerDelegate

- (void)roomsViewController:(RoomsViewController *)roomsViewController
     askedToJoinRoomAtIndex:(NSUInteger)index {
    [self.socketController joinRoomAtIndex:index];
}

- (void)roomsViewController:(RoomsViewController *)roomsViewController
    askedToLeaveRoomAtIndex:(NSUInteger)index {
    [self.socketController leaveRoomAtIndex:index];
}

- (void)roomsViewController:(RoomsViewController *)roomsViewController
         askedToSendMessage:(NSString *)message
              toRoomAtIndex:(NSUInteger)index {
    [self.socketController sendMessage:message
                           roomAtIndex:index];
}

@end
