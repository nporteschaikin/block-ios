//
//  RoomNavigatorSearchResultsController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/14/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorSearchResultsController.h"

@interface RoomNavigatorSearchResultsController ()

@property (strong, nonatomic) NSArray *rooms;

@end

@implementation RoomNavigatorSearchResultsController

- (void)updateSearchResults:(NSArray *)rooms {
    self.rooms = rooms;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}

- (RoomNavigatorTableViewCell *)tableView:(UITableView *)tableView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomNavigatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSDictionary *room = [self.rooms objectAtIndex:indexPath.row];
    NSString *name = [room objectForKey:@"name"];
    [cell setName:name];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *room = [self.rooms objectAtIndex:indexPath.row];
    [self.theDelegate roomSelected:room
           searchResultsController:self];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

@end
