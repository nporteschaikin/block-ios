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
#import "CreateRoomViewController.h"
#import "MainViewControllerAnimator.h"
#import "SocketController.h"
#import "UIColor+Block.h"
#import "Constants.h"

@interface MainViewController () <LoginViewControllerDelegate, FindingCityViewControllerDelegate,
    SocketControllerDelegate, MessengerViewControllerDelegate, RoomNavigatorControllerDelegate,
    CreateRoomViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) SocketController *socketController;
@property (strong, nonatomic) SessionManager *sessionManager;

@property (strong, nonatomic) FindingCityViewController *findingCityViewController;
@property (strong, nonatomic) SelectCityViewController *selectCityViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) RoomNavigatorViewController *roomNavigatorViewController;
@property (strong, nonatomic) CreateRoomViewController *createRoomViewController;
@property (strong, nonatomic) NSMutableArray *messengerViewControllers;

@property (strong, nonatomic, readonly) UIView *navigationControllerView;
@property (strong, nonatomic, readonly) UIView *roomNavigatorView;

@property (strong, nonatomic) MainViewControllerAnimator *animator;

@property (nonatomic) BOOL roomNavigatorViewIsOpen;
@property (nonatomic) NSUInteger currentMessengerViewControllerIndex;

@end

@implementation MainViewController

- (id)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blockGreyColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.navigationController];
    [self.view addSubview:self.navigationControllerView];
    [self.navigationController didMoveToParentViewController:self];
    [self addChildViewController:self.roomNavigatorViewController];
    [self.view insertSubview:self.roomNavigatorView
                belowSubview:self.navigationControllerView];
    [self.roomNavigatorViewController didMoveToParentViewController:self];
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
    self.socketController = [[SocketController alloc] initWithCityID:[city objectForKey:IOCityIDAttribute]
                                                      sessionManager:self.sessionManager
                                                            delegate:self];
    [self.socketController connect];
}

- (void)createMessengerViewControllerForRoom:(NSDictionary *)room {
    MessengerViewController *messengerViewController = [[MessengerViewController alloc] initWithRoom:room
                                                                                                user:self.sessionManager.user];
    messengerViewController.theDelegate = self;
    [self.messengerViewControllers addObject:messengerViewController];
}

- (void)requestMessageHistoryAtIndex:(NSUInteger)index {
    [self.socketController requestMessageHistoryAtIndex:index];
}

- (void)removeMessengerViewControllerAtIndex:(NSUInteger)index {
    MessengerViewController *messengerViewController = [self.messengerViewControllers objectAtIndex:index];
    [self.messengerViewControllers removeObject:messengerViewController];
    [self viewMessengerViewControllerAtIndex:0];
}

- (void)viewMessengerViewControllerAtIndex:(NSUInteger)index {
    if (index < self.messengerViewControllers.count) {
        MessengerViewController *viewController = [self.messengerViewControllers objectAtIndex:index];
        if ([self.navigationController.viewControllers containsObject:viewController]) {
            if (self.navigationController.topViewController != viewController) {
                [self.navigationController popToViewController:viewController
                                                      animated:YES];
            }
        } else {
            [self.navigationController pushViewController:viewController
                                                 animated:YES];
        }
        self.currentMessengerViewControllerIndex = index;
    } else {
        [self viewMessengerViewControllerAtIndex:0];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)openRoomNavigatorView:(BOOL)open
                       offset:(CGFloat)offset {
    self.roomNavigatorViewIsOpen = open;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect viewFrame = self.navigationControllerView.frame;
                         viewFrame.origin.x = open ? (CGRectGetWidth(viewFrame) - offset) : (0 + offset);
                         self.navigationControllerView.frame = viewFrame;
                     } completion:^(BOOL finished) {
                         [self.roomNavigatorViewController didMoveToParentViewController:self];
                     }];
}

- (NSMutableArray *)messengerViewControllers {
    if (!_messengerViewControllers) {
        _messengerViewControllers = [NSMutableArray array];
    }
    return _messengerViewControllers;
}

- (void)openCreateRoomViewController {
    [self addChildViewController:self.createRoomViewController];
    [self.view addSubview:self.createRoomViewController.view];
    self.createRoomViewController.view.alpha = 0.0f;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.createRoomViewController.view.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         [self.createRoomViewController didMoveToParentViewController:self];
                     }];
}

- (void)closeCreateRoomViewController {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.createRoomViewController.view.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [self.createRoomViewController.view removeFromSuperview];
                         [self.createRoomViewController removeFromParentViewController];
                         [self.createRoomViewController didMoveToParentViewController:nil];
                         self.createRoomViewController = nil;
                     }];
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
    self.roomNavigatorViewController.city = socketController.city;
    self.roomNavigatorViewController.cityID = socketController.cityID;
    self.roomNavigatorViewController.rooms = socketController.rooms;
    self.createRoomViewController.city = socketController.city;
    self.createRoomViewController.cityID = socketController.cityID;
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)socketReconnected:(SocketController *)socketController {
    for (NSUInteger i=0; i<self.messengerViewControllers.count; i++) {
        [self requestMessageHistoryAtIndex:i];
    }
}

- (void)socketDisconnected:(SocketController *)socketController
                 withError:(NSError *)error {
    [socketController reconnect];
}

- (void)sessionRoomsSentWithSocketController:(SocketController *)socketController {
    NSArray *messengerViewControllers = [NSArray arrayWithArray:self.messengerViewControllers];
    [self.messengerViewControllers removeAllObjects];
    if (socketController.rooms.count) {
        NSUInteger i=0;
        for (NSDictionary *room in socketController.rooms) {
            if (i < messengerViewControllers.count) {
                MessengerViewController *messengerViewController = [messengerViewControllers objectAtIndex:i];
                if ([(NSString *)[messengerViewController.room objectForKey:IORoomIDAttribute]
                     isEqualToString:(NSString *)[room objectForKey:IORoomIDAttribute]]) {
                    [self.messengerViewControllers addObject:messengerViewController];
                    messengerViewController.room = room;
                }
            }
            if (i >= self.messengerViewControllers.count) {
                [self createMessengerViewControllerForRoom:room];
            }
            [self requestMessageHistoryAtIndex:i];
            i++;
        }
        [self viewMessengerViewControllerAtIndex:self.currentMessengerViewControllerIndex || 0];
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
    [self requestMessageHistoryAtIndex:index];
    [self.roomNavigatorViewController openRoomAtIndex:index];
}

- (void)roomLeftAtIndex:(NSUInteger)index
       socketController:(SocketController *)socketController {
    [self removeMessengerViewControllerAtIndex:index];
    [self.roomNavigatorViewController leaveRoomAtIndex:index];
}

- (void)messageHistorySent:(NSArray *)messages
             inRoomAtIndex:(NSUInteger)index
              lastReadDate:(NSDate *)lastReadDate
          socketController:(SocketController *)socketController {
    MessengerViewController *messengerViewController = [self.messengerViewControllers objectAtIndex:index];
    [messengerViewController setMessageHistory:messages
                                  lastReadDate:lastReadDate];
}

- (void)messageSent:(NSDictionary *)message
             byUser:(NSDictionary *)user
      inRoomAtIndex:(NSUInteger)index
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

- (void)handleMessengerViewControllerLeftBarButtonItem:(MessengerViewController *)messengerViewController {
    [self openRoomNavigatorView:YES
                         offset:60.f];
}

- (void)handleMessengerViewControllerRightBarButtonItem:(MessengerViewController *)messengerViewController {
    if (self.socketController.rooms.count >= 2) {
        NSUInteger index = [self.messengerViewControllers indexOfObject:messengerViewController];
        [self.socketController leaveRoomAtIndex:index];
    }
}

- (void)messengerViewControllerTableViewTapped:(MessengerViewController *)messengerViewController {
    if (self.roomNavigatorViewIsOpen) {
        [self openRoomNavigatorView:NO
                             offset:0];
    }
}

- (void)messengerViewControllerTableViewSwipedLeft:(MessengerViewController *)messengerViewController {
    NSUInteger thisIndex = [self.messengerViewControllers indexOfObject:messengerViewController];
    NSUInteger nextIndex = thisIndex + 1;
    if (nextIndex < self.messengerViewControllers.count
        && !self.roomNavigatorViewIsOpen) {
        [self viewMessengerViewControllerAtIndex:nextIndex];
    }
    [self openRoomNavigatorView:NO
                         offset:0];
}
- (void)messengerViewControllerTableViewSwipedRight:(MessengerViewController *)messengerViewController {
    NSUInteger thisIndex = [self.messengerViewControllers indexOfObject:messengerViewController];
    NSUInteger nextIndex = thisIndex - 1;
    if (nextIndex == -1) {
        [self openRoomNavigatorView:YES
                             offset:60];
    } else {
        if (!self.roomNavigatorViewIsOpen) {
           [self viewMessengerViewControllerAtIndex:nextIndex];
        }
        [self openRoomNavigatorView:NO
                             offset:0];
    }
}

#pragma mark - Navigation controller

- (UINavigationController *)navigationController {
    if (!_navigationController) {
        _navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        _navigationController.delegate = self;
        _navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
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

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC {
    return self.animator;
}

- (MainViewControllerAnimator *)animator {
    if (!_animator) {
        _animator = [[MainViewControllerAnimator alloc] initWithMessengerViewControllers:self.messengerViewControllers
                                                                                transitionDuration:0.25f];
    }
    return _animator;
}

#pragma mark - RoomNavigatorViewController

- (RoomNavigatorViewController *)roomNavigatorViewController {
    if (!_roomNavigatorViewController) {
        _roomNavigatorViewController = [[RoomNavigatorViewController alloc] init];
        _roomNavigatorViewController.theDelegate = self;
    }
    return _roomNavigatorViewController;
}

- (UIView *)roomNavigatorView {
    return self.roomNavigatorViewController.view;
}

#pragma mark - RoomNavigatorViewControllerDelegate

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                         openedRoom:(NSDictionary *)room {
    if ([self.socketController roomExists:room]) {
        NSUInteger index = [self.socketController roomIndexByRoom:room];
        [self roomNavigatorViewController:roomNavigatorViewController
                      selectedRoomAtIndex:index];
    } else {
        [self.socketController joinRoom:room];
        [self openRoomNavigatorView:NO
                             offset:0];
    }
}

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigatorViewController
                selectedRoomAtIndex:(NSUInteger)index {
    [self viewMessengerViewControllerAtIndex:index];
    [self openRoomNavigatorView:NO
                         offset:0];
}

- (void)roomNavigatorViewControllerBeganSearch:(RoomNavigatorViewController *)roomNavigatorViewController {
    [self openRoomNavigatorView:YES
                         offset:0];
}

- (void)roomNavigatorViewControllerEndedSearch:(RoomNavigatorViewController *)roomNavigatorViewController {
    [self openRoomNavigatorView:YES
                         offset:60];
}

- (void)roomNavigatorViewControllerAskedToEditSettings:(RoomNavigatorViewController *)roomNavigatorViewController {
    [self openRoomNavigatorView:NO
                         offset:0];
}

- (void)roomNavigatorViewController:(RoomNavigatorViewController *)roomNavigationViewController
                             action:(RoomNavigatorViewControllerAction)action {
    [self openRoomNavigatorView:NO
                         offset:0];
    switch (action) {
        case RoomNavigatorViewControllerActionCreateNewRoom:
            [self openCreateRoomViewController];
            break;
        default:
            break;
    }
}

#pragma mark - CreateRoomViewController

- (CreateRoomViewController *)createRoomViewController {
    if (!_createRoomViewController) {
        _createRoomViewController = [[CreateRoomViewController alloc] init];
        _createRoomViewController.theDelegate = self;
    }
    return _createRoomViewController;
}

#pragma mark - CreateRoomViewControllerDelegate

- (void)createRoomViewController:(CreateRoomViewController *)createRoomViewController
                     createdRoom:(NSDictionary *)room {
    [self.socketController joinRoom:room];
    [self closeCreateRoomViewController];
}

- (void)dismissCreateRoomViewController:(CreateRoomViewController *)createRoomViewController {
    [self closeCreateRoomViewController];
}

@end
