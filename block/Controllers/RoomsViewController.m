//
//  RoomsViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomsViewController.h"
#import "RoomsNavigationController.h"
#import "RoomNavigatorViewController.h"
#import "MessengerViewController.h"
#import "SocketController.h"
#import "Constants.h"

float const targetForNavigator = 60.f;

@interface RoomsViewController () <RoomsNavigationControllerDelegate, RoomNavigatorControllerDelegate>

@property (strong, nonatomic) NSDictionary *city;
@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) NSMutableArray *openRooms;
@property (strong, nonatomic) RoomsNavigationController *roomsNavigationController;
@property (strong, nonatomic) RoomNavigatorViewController *roomNavigatorViewController;

@end

@implementation RoomsViewController

- (id)initWithCity:(NSDictionary *)city
             rooms:(NSArray *)rooms
         openRooms:(NSMutableArray *)openRooms {
    if (self = [super init]) {
        self.city = city;
        self.rooms = rooms;
        self.openRooms = openRooms;
        self.definesPresentationContext = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.roomsNavigationController];
    [self addChildViewController:self.roomNavigatorViewController];
    [self.roomsNavigationController didMoveToParentViewController:self];
    [self.roomNavigatorViewController didMoveToParentViewController:self];
    [self.view addSubview:self.roomsNavigationController.view];
    [self.view insertSubview:self.roomNavigatorViewController.view
                     atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.roomNavigatorViewController.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.roomNavigatorViewController.view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.roomNavigatorViewController.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-targetForNavigator]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.roomNavigatorViewController.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    [super updateViewConstraints];
}

- (void)openRoomsNavigatorView:(BOOL)open {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect viewFrame = self.roomsNavigationController.view.frame;
                         viewFrame.origin.x = (open ? (CGRectGetWidth(viewFrame) - targetForNavigator) : 0);
                         self.roomsNavigationController.view.frame = viewFrame;
                     } completion:nil];
}

- (void)openSessionRooms {
    [self.roomNavigatorViewController openSessionRooms];
    [self.roomsNavigationController openSessionRooms];
}

- (void)openRoomAtIndex:(NSUInteger)index {
    [self.roomsNavigationController openRoomAtIndex:index
                                               view:YES
                                           animated:YES];
    [self.roomNavigatorViewController openRoomAtIndex:index];
}

- (void)leaveRoomAtIndex:(NSUInteger)index {
    [self.roomsNavigationController leaveRoomAtIndex:index];
    [self.roomNavigatorViewController leaveRoomAtIndex:index];
}

- (void)addMessage:(NSDictionary *)message
          fromUser:(NSDictionary *)user
     toRoomAtIndex:(NSUInteger)index {
    [self.roomsNavigationController addMessage:message
                                      fromUser:user
                                 toRoomAtIndex:index];
}

- (void)addMessages:(NSArray *)messages
      toRoomAtIndex:(NSUInteger)index {
    [self.roomsNavigationController addMessages:messages
                                   toRoomAtIndex:index];
}

#pragma mark - RoomNavigationControllerDelegate

- (void)roomsNavigationController:(RoomsNavigationController *)roomsNavigationController
                      messageSent:(NSString *)message
                     inRoomAtIndex:(NSUInteger)index {
    [self.theDelegate roomsViewController:self
                       askedToSendMessage:message
                            toRoomAtIndex:index];
}

- (void)roomsNavigationController:(RoomsNavigationController *)roomsNavigationController
          askedToLeaveRoomAtIndex:(NSUInteger)index {
    [self.theDelegate roomsViewController:self
                  askedToLeaveRoomAtIndex:index];
}

- (void)leftBarButtonTappedInRoomsNavigationController:(RoomsNavigationController *)roomsNavigationController {
    [self openRoomsNavigatorView:YES];
}

#pragma mark - RoomNavigatorViewControllerDelegate

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                selectedRoomAtIndex:(NSUInteger)index {
    [self.roomsNavigationController viewRoomAtIndex:index
                                           animated:YES];
    [self openRoomsNavigatorView:NO];
}

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                  openedRoomAtIndex:(NSUInteger)index {
    [self.theDelegate roomsViewController:self
                   askedToJoinRoomAtIndex:index];
    [self openRoomsNavigatorView:NO];
}

#pragma mark - Child view controllers

- (RoomsNavigationController *)roomsNavigationController {
    if (!_roomsNavigationController) {
        _roomsNavigationController = [[RoomsNavigationController alloc] initWithRooms:self.rooms
                                                                            openRooms:self.openRooms];
        _roomsNavigationController.theDelegate = self;
    }
    return _roomsNavigationController;
}

- (RoomNavigatorViewController *)roomNavigatorViewController {
    if (!_roomNavigatorViewController) {
        _roomNavigatorViewController = [[RoomNavigatorViewController alloc] initWithCity:self.city
                                                                                   rooms:self.rooms
                                                                               openRooms:self.openRooms];
        _roomNavigatorViewController.theDelegate = self;
        _roomNavigatorViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _roomNavigatorViewController;
}

@end
