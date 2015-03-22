//
//  MessagesTableViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/13/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "MessageTableViewCell.h"

NSString * const reuseIdentifier = @"reuseIdentifier";

@interface MessagesTableViewController ()

@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation MessagesTableViewController

- (id)init {
    if (self = [super init]) {
        self.messages = [NSMutableArray array];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.contentInset = UIEdgeInsetsMake(14, 0, 14, 0);
        self.tableView.allowsSelection = NO;
        [self.tableView registerClass:[MessageTableViewCell class]
               forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottomAnimated:NO];
}

- (void)setMessageHistory:(NSArray *)messages {
    if (messages.count) {
        [self.messages removeAllObjects];
        [self.messages addObjectsFromArray:messages];
        [self.tableView reloadData];
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
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self scrollToBottomAnimated:YES];
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

- (void)configureCell:(MessageTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    NSDictionary *user = [message objectForKey:@"user"];
    [cell setMessage:[message objectForKey:@"message"]];
    [cell setUserName:[user objectForKey:@"name"]];
    [cell setTimeAgo:[message objectForKey:@"createdAt"]];
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
