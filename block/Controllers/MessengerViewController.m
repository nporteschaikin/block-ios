//
//  MessengerViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessengerViewController.h"
#import "MessagesTableViewController.h"
#import "BlockTextField.h"
#import "Constants.h"

@interface MessengerViewController () <UITextFieldDelegate>

@property (nonatomic, readwrite) BOOL didSetupConstraints;
@property (strong, nonatomic, readwrite) NSDictionary *room;
@property (strong, nonatomic) MessagesTableViewController *tableViewController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) BlockTextField *textField;
@property (strong, nonatomic) NSLayoutConstraint *textFieldBottomConstraint;

@end

@implementation MessengerViewController

- (id)initWithRoom:(NSDictionary *)room {
    if (self = [self init]) {
        self.room = room;
        [self.view addSubview:self.textField];
        [self addChildViewController:self.tableViewController];
        [self.view addSubview:self.tableViewController.view];
        [self.tableViewController didMoveToParentViewController:self];
        [self.view addSubview:self.textField];
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
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSwipe:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handleSwipe:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    
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
    [self.textField endEditing:YES];
}

- (void)updateViewConstraints {
    if (!self.didSetupConstraints) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
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
                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                 toItem:self.textField
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textField
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:-1]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textField
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:1]];
        [self.view addConstraint:self.textFieldBottomConstraint];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField.text length] > 0 || textField.text != nil || [textField.text isEqual:@""] == FALSE) {
        [self.theDelegate messengerViewController:self
                                      messageSent:textField.text];
        textField.text = nil;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.tableViewController scrollToBottomAnimated:YES];
}

#pragma mark - Keyboard notification target

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat startY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue]);
    CGFloat endY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    NSTimeInterval movementDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.textFieldBottomConstraint) {
        self.textFieldBottomConstraint.constant = (self.textFieldBottomConstraint.constant) + (endY - startY);
    }
    [UIView animateWithDuration:movementDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Handle bar button items

- (void)handleLeftBarButtonItem {
    [self.textField endEditing:YES];
    [self.theDelegate handleMessengerViewControllerLeftBarButtonItem:self];
}

- (void)handleRightBarButtonItem {
    [self.textField endEditing:YES];
    [self.theDelegate handleMessengerViewControllerRightBarButtonItem:self];
}

#pragma mark - Handle gesture recognizers

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe {
    [self.textField endEditing:YES];
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.theDelegate messengerViewControllerSwipedLeft:self];
    } else {
        [self.theDelegate messengerViewControllerSwipedRight:self];
    }
}

- (void)handleTableViewTap:(UITapGestureRecognizer *)tap {
    if (self.textField.isEditing) {
        [self.textField endEditing:YES];
    }
}

#pragma mark - Table view controller

- (MessagesTableViewController *)tableViewController {
    if (!_tableViewController) {
        _tableViewController = [[MessagesTableViewController alloc] init];
    }
    return _tableViewController;
}

- (UITableView *)tableView {
    return self.tableViewController.tableView;
}

#pragma mark - Text field

- (BlockTextField *)textField {
    if (!_textField) {
        _textField = [[BlockTextField alloc] init];
        _textField.delegate = self;
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.frame = CGRectInset(_textField.frame, -1, -1);
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 1;
    }
    return _textField;
}

- (NSLayoutConstraint *)textFieldBottomConstraint {
    if (!_textFieldBottomConstraint) {
        _textFieldBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textField
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0];
    }
    return _textFieldBottomConstraint;
}

@end
