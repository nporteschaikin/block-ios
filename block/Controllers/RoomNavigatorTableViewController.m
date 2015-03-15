//
//  RoomNavigatorTableViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/15/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorTableViewController.h"

@implementation RoomNavigatorTableViewController

- (id)init {
    if (self = [super init]) {
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[RoomNavigatorTableViewCell class]
           forCellReuseIdentifier:reuseIdentifier];
}

@end
