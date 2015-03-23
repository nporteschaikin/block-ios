//
//  MessengerViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessengerViewController.h"
#import "MessagesTableViewController.h"
#import "MessengerToolbar.h"
#import "Constants.h"

@interface MessengerViewController () <MessengerToolbarDelegate>

@property (nonatomic, readwrite) BOOL didSetupConstraints;
@property (strong, nonatomic, readwrite) NSDictionary *room;
@property (strong, nonatomic) MessagesTableViewController *tableViewController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MessengerToolbar *messengerToolbar;
@property (strong, nonatomic) NSLayoutConstraint *messengerToolbarBottomConstraint;

@end

@implementation MessengerViewController

- (id)initWithRoom:(NSDictionary *)room {
    if (self = [self init]) {
        self.room = room;
        
        [self addChildViewController:self.tableViewController];
        [self.view addSubview:self.tableViewController.view];
        
        [self.tableViewController didMoveToParentViewController:self];
        [self.view addSubview:self.messengerToolbar];
    }
    return self;
}

- (void)setupNavigationBarItems {
    self.navigationItem.title = [self.room objectForKey:@"name"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                          target:self
                                                                                          action:@selector(handleLeftBarButtonItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                           target:self
                                                                                           action:@selector(handleRightBarButtonItem)];
}

- (void)setupKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupGestureRecognizers {
    // tap
    UITapGestureRecognizer *tableViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(handleTableViewTap:)];
    [self.tableViewController.tableView addGestureRecognizer:tableViewTapGestureRecognizer];
    
    // left swipe
    UISwipeGestureRecognizer *tableViewSwipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                              action:@selector(handleTableViewSwipeLeft:)];
    tableViewSwipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableViewController.tableView addGestureRecognizer:tableViewSwipeLeftGestureRecognizer];
    
    // right swipe
    UISwipeGestureRecognizer *tableViewSwipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                               action:@selector(handleTableViewSwipeRight:)];
    tableViewSwipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableViewController.tableView addGestureRecognizer:tableViewSwipeRightGestureRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarItems];
    [self setupKeyboardObserver];
    [self setupGestureRecognizers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    if (!self.didSetupConstraints) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableViewController.view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.topLayoutGuide
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableViewController.view
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableViewController.view
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableViewController.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.messengerToolbar
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messengerToolbar
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messengerToolbar
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messengerToolbar
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:self.messengerToolbarBottomConstraint];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user {
    [self.tableViewController addMessage:message
                                  byUser:user];
}

- (void)setMessageHistory:(NSArray *)messages {
    [self.tableViewController setMessageHistory:messages];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat startY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue]);
    CGFloat endY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    NSTimeInterval movementDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.messengerToolbarBottomConstraint) {
        self.messengerToolbarBottomConstraint.constant = (self.messengerToolbarBottomConstraint.constant) + (endY - startY);
    }
    [UIView animateWithDuration:movementDuration
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)handleLeftBarButtonItem {
    [self.messengerToolbar.textView endEditing:YES];
    [self.theDelegate handleMessengerViewControllerLeftBarButtonItem:self];
}

- (void)handleRightBarButtonItem {
    [self.messengerToolbar.textView endEditing:YES];
    [self.theDelegate handleMessengerViewControllerRightBarButtonItem:self];
}

- (void)handleTableViewTap:(UITapGestureRecognizer *)tap {
    [self.messengerToolbar.textView endEditing:YES];
    [self.theDelegate messengerViewControllerTableViewTapped:self];
}

- (void)handleTableViewSwipeLeft:(UITapGestureRecognizer *)swipe {
    [self.messengerToolbar.textView endEditing:YES];
    [self.theDelegate messengerViewControllerTableViewSwipedLeft:self];
}

- (void)handleTableViewSwipeRight:(UITapGestureRecognizer *)swipe {
    [self.messengerToolbar.textView endEditing:YES];
    [self.theDelegate messengerViewControllerTableViewSwipedRight:self];
}

- (MessagesTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[MessagesTableViewController alloc] init];
    }
    return _tableViewController;
}

- (MessengerToolbar *)messengerToolbar {
    if (!_messengerToolbar) {
        _messengerToolbar = [[MessengerToolbar alloc] initWithFrame:CGRectMake(0, 200, 200, 50)];
        _messengerToolbar.translatesAutoresizingMaskIntoConstraints = NO;
        _messengerToolbar.theDelegate = self;
    }
    return _messengerToolbar;
}

- (NSLayoutConstraint *)messengerToolbarBottomConstraint {
    if (!_messengerToolbarBottomConstraint) {
        _messengerToolbarBottomConstraint = [NSLayoutConstraint constraintWithItem:self.messengerToolbar
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0];
    }
    return _messengerToolbarBottomConstraint;
}

- (void)messengerToolbar:(MessengerToolbar *)messengerToolbar
         askedToSendText:(NSString *)text {
    if (![text isEqualToString:@""]) {
        [self.theDelegate messengerViewController:self
                                      messageSent:text];
    }
}

- (void)messengerToolbar:(MessengerToolbar *)messengerToolbar
         didChangeHeight:(CGFloat)diff {
    [self.tableViewController scrollToBottomAnimated:NO];
}

@end
