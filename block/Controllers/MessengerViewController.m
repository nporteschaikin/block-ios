//
//  MessengerViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessengerViewController.h"
#import "MessageTableViewCell.h"
#import "BlockTextField.h"
#import "Constants.h"

NSString * const tableViewCellReuseIdentifier = @"tableViewCellReuseIdentifier";

@interface MessengerViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, readwrite) BOOL didSetupConstraints;

@property (strong, nonatomic, readwrite) NSDictionary *room;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) BlockTextField *messageTextField;
@property (strong, nonatomic) NSLayoutConstraint *messageTextFieldBottomConstraint;

@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation MessengerViewController

- (id)initWithRoom:(NSDictionary *)room {
    if (self = [self init]) {
        self.room = room;
        self.messages = [NSMutableArray array];
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.messageTextField];
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
    [self.view addGestureRecognizer:tableViewGestureRecognizer];
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
    [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.messageTextField endEditing:YES];
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
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.messageTextField
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.messageTextField
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageTextField
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:-1]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.messageTextField
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:1]];
        [self.view addConstraint:self.messageTextFieldBottomConstraint];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 55.0f;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[MessageTableViewCell class]
                   forCellReuseIdentifier:tableViewCellReuseIdentifier];
    }
    return _tableView;
}

- (BlockTextField *)messageTextField {
    if (!_messageTextField) {
        _messageTextField = [[BlockTextField alloc] init];
        _messageTextField.delegate = self;
        _messageTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _messageTextField.frame = CGRectInset(_messageTextField.frame, -1, -1);
        _messageTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _messageTextField.layer.borderWidth = 1;
    }
    return _messageTextField;
}

- (NSLayoutConstraint *)messageTextFieldBottomConstraint {
    if (!_messageTextFieldBottomConstraint) {
        _messageTextFieldBottomConstraint = [NSLayoutConstraint constraintWithItem:self.messageTextField
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0];
    }
    return _messageTextFieldBottomConstraint;
}

- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user {
    NSMutableDictionary *theMessage = [NSMutableDictionary dictionaryWithDictionary:message];
    [theMessage setObject:user
                   forKey:@"user"];
    [self.messages addObject:theMessage];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:NO];
}

- (void)setMessageHistory:(NSArray *)messages {
    if (messages.count) {
        self.messages = [NSMutableArray arrayWithArray:messages];
        [self.tableView reloadData];
        [self scrollToBottomAnimated:NO];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger lastIndex = self.messages.count - 1;
    if (lastIndex >= 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndex
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
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
    [self scrollToBottomAnimated:YES];
}

#pragma mark - Keyboard notification target

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat startY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue]);
    CGFloat endY = CGRectGetMidY([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    NSTimeInterval movementDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.messageTextFieldBottomConstraint) {
        self.messageTextFieldBottomConstraint.constant = (self.messageTextFieldBottomConstraint.constant) + (endY - startY);
    }
    [UIView animateWithDuration:movementDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellReuseIdentifier];
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    NSDictionary *user = [message objectForKey:@"user"];
    [cell setMessage:[message objectForKey:@"message"]];
    [cell setUserName:[user objectForKey:@"name"]];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) return self.messages.count;
    return 1;
}

#pragma mark - Handle bar button items

- (void)handleLeftBarButtonItem {
    [self.theDelegate handleMessengerViewControllerLeftBarButtonItem:self];
}

- (void)handleRightBarButtonItem {
    [self.theDelegate handleMessengerViewControllerRightBarButtonItem:self];
}

#pragma mark - Handle gesture recognizers

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.theDelegate messengerViewControllerSwipedLeft:self];
    } else {
        [self.theDelegate messengerViewControllerSwipedRight:self];
    }
}

- (void)handleTableViewTap:(UITapGestureRecognizer *)tap {
    if (self.messageTextField.isEditing) {
        [self.messageTextField endEditing:YES];
    }
}

@end
