//
//  RoomNavigatorSearchResultsController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/14/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorSearchResultsController.h"
#import "RoomNavigatorTableViewCell.h"
#import "RoomNavigatorTableView.h"
#import "APIManager+Cities.h"

static NSString * const reuseIdentifier = @"RoomNavigatorSearchResultsControllerCell";

@interface RoomNavigatorSearchResultsController ()

@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSArray *rooms;

@end

@implementation RoomNavigatorSearchResultsController

- (id)initWithCityID:(NSString *)cityID {
    if (self = [super init]) {
        self.tableView = [[RoomNavigatorTableView alloc] init];
        self.cityID = cityID;
        [self.tableView registerClass:[RoomNavigatorTableViewCell class]
               forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateSearchResultsWithQuery:(NSString *)query {
    [APIManager searchForRoom:query
                 inCityWithID:self.cityID
                   onComplete:^(NSArray *rooms) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           self.rooms = rooms;
                           [self.tableView reloadData];
                       });
                   }];
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

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
