//
//  RoomsNavigationController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomsNavigationController.h"
#import "MessengerViewController.h"

@interface RoomsNavigationController () <MessengerViewControllerDelegate>

@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) NSMutableArray *openRooms;
@property (strong, nonatomic) NSMutableArray *allViewControllers;
@property (nonatomic) NSUInteger currentIndex;

@end

@implementation RoomsNavigationController

- (id)initWithRooms:(NSArray *)rooms
          openRooms:(NSMutableArray *)openRooms {
    if (self = [super initWithRootViewController:[[UIViewController alloc] init]]) {
        self.rooms = rooms;
        self.openRooms = openRooms;
        self.allViewControllers = [NSMutableArray array];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (MessengerViewController *)viewControllerForRoomByID:(NSString *)roomID {
    NSUInteger index = [self.openRooms indexOfObject:roomID];
    return [self.allViewControllers objectAtIndex:index];
}

- (void)openSessionRooms {
    for (NSUInteger i=0; i<self.openRooms.count; i++) {
        [self openRoomAtIndex:i
                         view:NO
                     animated:NO];
    }
    [self viewRoomAtIndex:0
                 animated:YES];
}

- (void)openRoomAtIndex:(NSUInteger)index
                   view:(BOOL)view
               animated:(BOOL)animated {
    NSDictionary *room = [self.openRooms objectAtIndex:index];
    MessengerViewController *viewController = [[MessengerViewController alloc] initWithRoom:room];
    viewController.theDelegate = self;
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                                        target:self
                                                                                                        action:@selector(handleLeftBarButton)];
    [self.allViewControllers addObject:viewController];
    if (view) {
        [self viewRoomAtIndex:index
                     animated:animated];
    }
}

- (void)viewRoomAtIndex:(NSUInteger)index
               animated:(BOOL)animated {
    if (index < self.allViewControllers.count) {
        MessengerViewController *viewController = [self.allViewControllers objectAtIndex:index];
        if (!self.topViewController) {
            [self setViewControllers:@[viewController]
                            animated:NO];
        } else if (![self.viewControllers containsObject:viewController]) {
            [self pushViewController:viewController
                            animated:animated];
        } else {
            [self setViewControllers:self.allViewControllers
                            animated:animated];
            [self popToViewController:viewController
                             animated:animated];

        }
    }
}

- (void)viewDidLoad {
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleLeftSwipe:)];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handleRightSwipe:)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}

- (void)addMessages:(NSArray *)messages
      toRoomAtIndex:(NSUInteger)index {
    MessengerViewController *messengerViewController = [self.allViewControllers objectAtIndex:index];
    [messengerViewController addMessages:messages];
}

- (void)addMessage:(NSDictionary *)message
          fromUser:(NSDictionary *)user
     toRoomAtIndex:(NSUInteger)index {
    MessengerViewController *messengerViewController = [self.allViewControllers objectAtIndex:index];
    [messengerViewController addMessage:message
                                 byUser:user];
}

- (void)leaveRoomAtIndex:(NSUInteger)index {
    [self.allViewControllers removeObjectAtIndex:index];
    [self viewRoomAtIndex:0
                 animated:YES];
}

#pragma mark - Left bar button item handler

- (void)handleLeftBarButton {
    [self.theDelegate leftBarButtonTappedInRoomsNavigationController:self];
}

#pragma mark - Gesture recognizer handlers

- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSInteger nextIndex = [self.allViewControllers indexOfObject:self.topViewController] + 1;
    [self viewRoomAtIndex:nextIndex
                 animated:YES];
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSInteger nextIndex = [self.allViewControllers indexOfObject:self.topViewController] - 1;
    [self viewRoomAtIndex:nextIndex
                 animated:YES];
}

#pragma mark - MessengerViewControllerDelegate

- (void)messengerViewController:(MessengerViewController *)messengerViewController
                    messageSent:(NSString *)message {
    NSUInteger index = [self.allViewControllers indexOfObject:messengerViewController];
    [self.theDelegate roomsNavigationController:self
                                    messageSent:message
                                  inRoomAtIndex:index];
}

- (void)messengerViewControllerAskedToLeave:(MessengerViewController *)messengerViewController {
    NSUInteger index = [self.allViewControllers indexOfObject:messengerViewController];
    [self.theDelegate roomsNavigationController:self
                        askedToLeaveRoomAtIndex:index];
}

@end
