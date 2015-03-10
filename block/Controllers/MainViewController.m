//
//  MainViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "RoomNavigatorViewController.h"
#import "FindingCityViewController.h"
#import "SelectCityViewController.h"
#import "MessengerViewController.h"
#import "SocketController.h"

@interface MainViewController () <LoginViewControllerDelegate, FindingCityViewControllerDelegate, SocketControllerDelegate, MessengerViewControllerDelegate, RoomNavigatorControllerDelegate>

@property (strong, nonatomic) SocketController *socketController;
@property (strong, nonatomic) SessionManager *sessionManager;

@property (strong, nonatomic) FindingCityViewController *findingCityViewController;
@property (strong, nonatomic) SelectCityViewController *selectCityViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) RoomNavigatorViewController *roomNavigatorViewController;
@property (strong, nonatomic) NSMutableArray *messengerViewControllers;

@property (strong, nonatomic, readonly) UIView *navigationControllerView;
@property (strong, nonatomic, readonly) UIView *roomNavigatorView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigationControllerView];
    [self start];
}

- (void)start {
    [SessionManager withSessionToken:^(SessionManager *sessionManager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setSessionManagerPresentFindingCityViewController:sessionManager];
        });
    } onFail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:self.loginViewController
                               animated:YES
                             completion:nil];
        });
    }];
}

- (void)setSessionManagerPresentFindingCityViewController:(SessionManager *)sessionManager {
    self.sessionManager = sessionManager;
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    [self presentViewController:self.findingCityViewController
                       animated:YES
                     completion:nil];
}

- (void)connectSocketControllerWithCity:(NSDictionary *)city {
    self.socketController = [[SocketController alloc] initWithCityID:[city objectForKey:@"id"]
                                                      sessionManager:self.sessionManager
                                                            delegate:self];
    [self.socketController connect];
}

- (void)createMessengerViewControllerForRoom:(NSDictionary *)room {
    MessengerViewController *messengerViewController = [[MessengerViewController alloc] initWithRoom:room];
    messengerViewController.theDelegate = self;
    [self.messengerViewControllers addObject:messengerViewController];
}

- (void)viewMessengerViewControllerAtIndex:(NSUInteger)index {
    if (index < self.messengerViewControllers.count) {
        MessengerViewController *messengerViewController = [self.messengerViewControllers objectAtIndex:index];
        if (![self.navigationController.viewControllers containsObject:messengerViewController]) {
            [self.navigationController pushViewController:messengerViewController
                                                 animated:YES];
        } else {
            [self.navigationController setViewControllers:[NSArray arrayWithArray:self.messengerViewControllers]
                                                 animated:NO];
            [self.navigationController popToViewController:messengerViewController
                                                  animated:YES];
            
        }
    }
}

- (void)openRoomNavigatorView:(BOOL)open {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect viewFrame = self.navigationControllerView.frame;
                         viewFrame.origin.x = (open ? (CGRectGetWidth(viewFrame) - 60.f) : 0);
                         self.navigationControllerView.frame = viewFrame;
                     } completion:nil];
}

- (NSMutableArray *)messengerViewControllers {
    if (!_messengerViewControllers) {
        _messengerViewControllers = [NSMutableArray array];
    }
    return _messengerViewControllers;
}

#pragma mark - LoginViewController

- (LoginViewController *)loginViewController {
    if (!_loginViewController) {
        _loginViewController = [[LoginViewController alloc] init];
        _loginViewController.delegate = self;
    }
    return _loginViewController;
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewController:(LoginViewController *)loginViewController
 didLogInWithSessionManager:(SessionManager *)sessionManager {
    [self setSessionManagerPresentFindingCityViewController:sessionManager];
}

#pragma mark - FindingCityViewController

- (FindingCityViewController *)findingCityViewController {
    if (!_findingCityViewController) {
        _findingCityViewController = [[FindingCityViewController alloc] initWithSessionManager:self.sessionManager];\
        _findingCityViewController.delegate = self;
    }
    return _findingCityViewController;
}

#pragma mark - FindingCityViewControllerDelegate

- (void)findingCityViewController:(FindingCityViewController *)findingCityViewController
                didFindSingleCity:(NSDictionary *)city {
    [self connectSocketControllerWithCity:city];
}

- (void)findingCityViewController:(FindingCityViewController *)findingCityViewController
            didFindMultipleCities:(NSArray *)cities {
    // nothing yet
}

#pragma mark - SocketControllerDelegate

- (void)socketConnected:(SocketController *)socketController {
    [self.view insertSubview:self.roomNavigatorView
                belowSubview:self.navigationControllerView];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)sessionRoomsSentWithSocketController:(SocketController *)socketController {
    if (socketController.openRooms.count) {
        for (NSDictionary *room in socketController.openRooms) {
            [self createMessengerViewControllerForRoom:room];
        }
        [self viewMessengerViewControllerAtIndex:0];
        [self.roomNavigatorViewController openSessionRooms];
    } else {
        [socketController joinDefaultRoom];
    }
}

- (void)roomJoinedAtIndex:(NSUInteger)index
         socketController:(SocketController *)socketController {
    NSDictionary *room = [socketController.rooms objectAtIndex:index];
    [self createMessengerViewControllerForRoom:room];
    [self viewMessengerViewControllerAtIndex:index];
    [self.roomNavigatorViewController openRoomAtIndex:index];
}

- (void)roomLeftAtIndex:(NSUInteger)index
       socketController:(SocketController *)socketController {
    // nothing yet
}

- (void)messageHistorySent:(NSArray *)messages
             inRoomAtIndex:(NSUInteger)index
          socketController:(SocketController *)socketController {
    MessengerViewController *messengerViewController = [self.messengerViewControllers objectAtIndex:index];
    [messengerViewController addMessages:messages];
}

- (void)messageSent:(NSDictionary *)message
      inRoomAtIndex:(NSUInteger)index
             byUser:(NSDictionary *)user
   socketController:(SocketController *)socketController {
    MessengerViewController *messengerViewController = [self.messengerViewControllers objectAtIndex:index];
    [messengerViewController addMessage:message
                                 byUser:user];
    
}

#pragma mark - MessengerViewControllerDelegate

- (void)messengerViewController:(MessengerViewController *)messengerViewController
                    messageSent:(NSString *)message {
    NSUInteger index = [self.messengerViewControllers indexOfObject:messengerViewController];
    [self.socketController sendMessage:message
                           roomAtIndex:index];
}

- (void)messengerViewControllerAskedToLeave:(MessengerViewController *)messengerViewController {
    NSUInteger index = [self.messengerViewControllers indexOfObject:messengerViewController];
    [self.socketController leaveRoomAtIndex:index];
}

- (void)handleMessengerViewControllerLeftBarButtonItem:(MessengerViewController *)messengerViewController {
    [self openRoomNavigatorView:YES];
}

- (void)messengerViewControllerSwipedLeft:(MessengerViewController *)messengerViewController {
    NSUInteger nextIndex = [self.messengerViewControllers indexOfObject:messengerViewController] + 1;
    [self viewMessengerViewControllerAtIndex:nextIndex];
}

- (void)messengerViewControllerSwipedRight:(MessengerViewController *)messengerViewController {
    NSUInteger nextIndex = [self.messengerViewControllers indexOfObject:messengerViewController] - 1;
    [self viewMessengerViewControllerAtIndex:nextIndex];
}

#pragma mark - Navigation controller

- (UINavigationController *)navigationController {
    if (!_navigationController) {
        _navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        UIView *view = _navigationController.view;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
        view.layer.masksToBounds = NO;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        view.layer.shadowOpacity = 0.5f;
        view.layer.shadowPath = path.CGPath;
        view.backgroundColor = [UIColor whiteColor];
    }
    return _navigationController;
}

- (UIView *)navigationControllerView {
    return self.navigationController.view;
}

#pragma mark - RoomNavigatorViewController

- (RoomNavigatorViewController *)roomNavigatorViewController {
    if (!_roomNavigatorViewController) {
        _roomNavigatorViewController = [[RoomNavigatorViewController alloc] initWithCity:self.socketController.city
                                                                                   rooms:self.socketController.rooms
                                                                               openRooms:self.socketController.openRooms];
        _roomNavigatorViewController.theDelegate = self;
    }
    return _roomNavigatorViewController;
}

- (UIView *)roomNavigatorView {
    return self.roomNavigatorViewController.view;
}

#pragma mark - RoomNavigatorViewControllerDelegate

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                  openedRoomAtIndex:(NSUInteger)index {
    [self.socketController joinRoomAtIndex:index];
    [self openRoomNavigatorView:NO];
}

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                selectedRoomAtIndex:(NSUInteger)index {
    [self viewMessengerViewControllerAtIndex:index];
    [self openRoomNavigatorView:NO];
}

@end