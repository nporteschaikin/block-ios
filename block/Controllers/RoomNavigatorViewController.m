//
//  RoomNavigatorViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorViewController.h"
#import "RoomNavigatorSearchResultsController.h"
#import "APIManager+Cities.h"

@interface RoomNavigatorViewController () <UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, RoomNavigatorSearchResultsControllerDelegate>

@property (strong, nonatomic) RoomNavigatorSearchResultsController *searchResultsController;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIButton *createNewRoomButton;

@end

@implementation RoomNavigatorViewController

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)openSessionRooms {
    [self.tableView reloadData];
}

- (void)openRoomAtIndex:(NSUInteger)index {
    [self.tableView reloadData];
}

- (void)leaveRoomAtIndex:(NSUInteger)index {
    [self.tableView reloadData];
}

#pragma mark - RoomNavigatorSearchResultsController

- (RoomNavigatorSearchResultsController *)searchResultsController {
    if (!_searchResultsController) {
        _searchResultsController = [[RoomNavigatorSearchResultsController alloc] init];
        _searchResultsController.theDelegate = self;
    }
    return _searchResultsController;
}

#pragma mark - UISearchController

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.delegate = self;
    }
    return _searchController;
}

- (BOOL)searchIsActive {
    return self.searchController.active;
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    [self.theDelegate roomNavigatorViewControllerBeganSearch:self];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [self.theDelegate roomNavigatorViewControllerEndedSearch:self];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *query = searchController.searchBar.text;
    [APIManager searchForRoom:query
                 inCityWithID:self.cityID
                   onComplete:^(NSArray *rooms) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self.searchResultsController updateSearchResults:rooms];
                       });
                   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"Open";
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
    NSUInteger index = indexPath.row;
    [self.theDelegate roomNavigatorViewController:self
                              selectedRoomAtIndex:index];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - RoomNavigatorSearchResultsControllerDelegate

- (void)roomSelected:(NSDictionary *)room
searchResultsController:(RoomNavigatorSearchResultsController *)searchResultsController {
    [self.theDelegate roomNavigatorViewController:self
                                       openedRoom:room];
    self.searchController.searchBar.text = nil;
    [self.searchController.searchBar resignFirstResponder];
}

@end
