//
//  MessengerViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessengerViewController.h"
#import "MessagesTableViewController.h"
#import "Constants.h"

@interface MessengerViewController () <UITextFieldDelegate>

@property (nonatomic, readwrite) BOOL didSetupConstraints;
@property (strong, nonatomic, readwrite) NSDictionary *room;
@property (strong, nonatomic) MessagesTableViewController *tableViewController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIToolbar *messageToolbar;
@property (strong, nonatomic) UITextField *messageToolbarTextField;
@property (strong, nonatomic) NSLayoutConstraint *messageToolbarBottomConstraint;

@end

@implementation MessengerViewController

- (id)initWithRoom:(NSDictionary *)room {
    if (self = [self init]) {
        self.room = room;
        [self addChildViewController:self.tableViewController];
        [self.view addSubview:self.tableViewController.view];
        [self.tableViewController didMoveToParentViewController:self];
        [self.view addSubview:self.messageToolbar];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
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
                                                                 toItem:self.messageToolbar
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageToolbar
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageToolbar
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageToolbar
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:self.messageToolbarBottomConstraint];
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

- (void)sendMessageWithTextField:(UITextField *)textField {
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendMessageWithTextField:textField];
    return YES;
}

#pragma mark - Keyboard notification target

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat startY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue]);
    CGFloat endY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    NSTimeInterval movementDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.messageToolbarBottomConstraint) {
        self.messageToolbarBottomConstraint.constant = (self.messageToolbarBottomConstraint.constant) + (endY - startY);
    }
    [UIView animateWithDuration:movementDuration
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
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

- (UIToolbar *)messageToolbar {
    if (!_messageToolbar) {
        _messageToolbar = [[UIToolbar alloc] init];
        _messageToolbar.translatesAutoresizingMaskIntoConstraints = NO;
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
        fixedSpace.width = 5.0f;
        _messageToolbar.items = @[
                                  [[UIBarButtonItem alloc] initWithCustomView:self.messageToolbarTextField],
                                  fixedSpace,
                                  [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil]
                                ];
        [_messageToolbar sizeToFit];
    }
    return _messageToolbar;
}

- (NSLayoutConstraint *)messageToolbarBottomConstraint {
    if (!_messageToolbarBottomConstraint) {
        _messageToolbarBottomConstraint = [NSLayoutConstraint constraintWithItem:self.messageToolbar
                                           
                                                                       attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:0];
    }
    return _messageToolbarBottomConstraint;
}

#pragma mark - Text field

- (UITextField *)messageToolbarTextField {
    if (!_messageToolbarTextField) {
        _messageToolbarTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 20, 28)];
        _messageToolbarTextField.delegate = self;
        _messageToolbarTextField.backgroundColor = [UIColor whiteColor];
        _messageToolbarTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleRightMargin;
//            UIViewAutoresizingFlexibleTopMargin |
//            UIViewAutoresizingFlexibleBottomMargin |
//            UIViewAutoresizingFlexibleLeftMargin;
            //UIViewAutoresizingFlexibleRightMargin;
    }
    return _messageToolbarTextField;
}

@end
