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

- (void)setNavigationBarItems {
    NSString *roomName = [self.room objectForKey:@"name"];
    if (roomName) self.navigationItem.title = roomName;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                          target:self
                                                                                          action:@selector(handleLeftBarButtonItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                           target:self
                                                                                           action:@selector(handleRightBarButtonItem)];
}

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *tableViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleTableViewTap:)];
    [self.tableView addGestureRecognizer:tableViewGestureRecognizer];
}

- (void)viewDidLoad {
    [self setNavigationBarItems];
    [self addKeyboardObserver];
    [self addGestureRecognizers];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
        //[self.view addConstraint:self.messengerToolbarBottomConstraint];
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

- (void)sendMessageWithTextField:(UITextView *)textField {
    if (![textField.text isEqualToString:@""]) {
        [self.theDelegate messengerViewController:self
                                      messageSent:textField.text];
        textField.text = nil;
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"A message is required."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Continue"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        [textField becomeFirstResponder];
    }
}

#pragma mark - Keyboard notification target

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    CGFloat startY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue]);
//    CGFloat endY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
//    NSTimeInterval movementDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    if (self.messengerToolbarBottomConstraint) {
//        self.messengerToolbarBottomConstraint.constant = (self.messengerToolbarBottomConstraint.constant) + (endY - startY);
//    }
//    [UIView animateWithDuration:movementDuration
//                     animations:^{
//                         [self.view layoutIfNeeded];
//                     }];
}
#pragma mark - Handle bar button items

- (void)handleLeftBarButtonItem {
    //[self.textField endEditing:YES];
    [self.theDelegate handleMessengerViewControllerLeftBarButtonItem:self];
}

- (void)handleRightBarButtonItem {
    //[self.textField endEditing:YES];
    [self.theDelegate handleMessengerViewControllerRightBarButtonItem:self];
}

#pragma mark - Handle gesture recognizers

- (void)handleTableViewTap:(UITapGestureRecognizer *)tap {
//    if (self.textField.isEditing) {
//        [self.textField endEditing:YES];
//    }
    [self.theDelegate messengerViewControllerTableViewTapped:self];
}

#pragma mark - Table view controller

- (MessagesTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[MessagesTableViewController alloc] init];
    }
    return _tableViewController;
}

#pragma mark - Toolbar

- (MessengerToolbar *)messengerToolbar {
    if (!_messengerToolbar) {
        _messengerToolbar = [[MessengerToolbar alloc] initWithFrame:CGRectMake(0,
                                                                               self.view.frame.size.height-50,
                                                                               self.view.frame.size.width,
                                                                               50)];
        _messengerToolbar.theDelegate = self;
        _messengerToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.messengerToolbar.frame = CGRectMake(0,
                                             self.view.frame.size.height-50,
                                             self.view.frame.size.width,
                                             50);
}

#pragma mark - MessengerToolbarDelegate

- (void)messengerToolbar:(MessengerToolbar *)messengerToolbar
       didChangeHeightBy:(CGFloat)diff {
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
}

@end
