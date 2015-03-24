//
//  MessagesTableViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/13/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "MessageTableViewCell.h"
#import "NSDate+ISO8601.h"
#import "Constants.h"

NSString * const reuseIdentifier = @"reuseIdentifier";

@interface MessagesTableViewController ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDate *lastReadDate;
@property (strong, nonatomic) NSDictionary *user;

@end

@implementation MessagesTableViewController

- (id)initWithUser:(NSDictionary *)user {
    if (self = [super init]) {
        self.user = user;
        self.messages = [NSMutableArray array];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.allowsSelection = NO;
        [self.tableView registerClass:[MessageTableViewCell class]
               forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self scrollToBottomAnimated:NO];
    [super viewWillAppear:animated];
}

- (void)setMessageHistory:(NSArray *)messages
             lastReadDate:(NSDate *)lastReadDate {
    if (messages.count) {
        self.lastReadDate = lastReadDate;
        [self.messages removeAllObjects];
        [self.messages addObjectsFromArray:messages];
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [self scrollToBottomAnimated:NO];
    }
}

- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user {
    NSMutableDictionary *theMessage = [NSMutableDictionary dictionaryWithDictionary:message];
    [theMessage setObject:user
                   forKey:@"user"];
    [self.messages addObject:theMessage];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.messages.count - 1)
                                                                inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self scrollToBottomAnimated:YES];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger lastIndex = self.messages.count - 1;
    if (lastIndex >= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndex
                                                                      inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
        });
    }
}

- (void)configureCell:(MessageTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    NSDictionary *user = [message objectForKey:@"user"];
    NSDate *createdAt = [NSDate dateWithISO8601:[message objectForKey:@"createdAt"]];
    cell.message = [message objectForKey:@"message"];
    cell.userName = [user objectForKey:@"name"];
    cell.createdAt = createdAt;
    cell.isCurrentUser = [(NSString *)[self.user objectForKey:IOUserIDAttribute]
                          isEqualToString:(NSString *)[user objectForKey:IOUserIDAttribute]];
    cell.isUnread = [createdAt compare:self.lastReadDate] == NSOrderedDescending;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [self configureCell:cell
            atIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
