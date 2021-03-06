//
//  RoomNavigatorSearchResultsController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/14/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorSearchResultsController.h"
#import "RoomNavigatorTableViewRoomCell.h"
#import "RoomNavigatorTableView.h"
#import "APIManager+Cities.h"

static NSString * const reuseIdentifier = @"RoomNavigatorTableViewRoomCell";

@interface RoomNavigatorSearchResultsController ()

@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSArray *rooms;

@end

@implementation RoomNavigatorSearchResultsController

- (id)initWithCityID:(NSString *)cityID {
    if (self = [super init]) {
        self.cityID = cityID;
        self.tableView = [[RoomNavigatorTableView alloc] init];
        [self.tableView registerClass:[RoomNavigatorTableViewRoomCell class]
               forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)updateSearchResultsWithQuery:(NSString *)query {
    if (![query isEqualToString:@""]) {
        [APIManager searchForRoom:query
                     inCityWithID:self.cityID
                        onSuccess:^(NSArray *rooms) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.rooms = rooms;
                                [self.tableView reloadData];
                            });
                        } onFail:^(NSURLResponse *response, NSData *data) {
                            // what?
                        } onError:^(NSError *error) {
                            // no internet connection
                        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}

- (RoomNavigatorTableViewRoomCell *)tableView:(UITableView *)tableView
                        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomNavigatorTableViewRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSDictionary *room = [self.rooms objectAtIndex:indexPath.row];
    cell.name = [room objectForKey:@"name"];
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

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
