//
//  RoomNavigatorViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorViewController.h"
#import "RoomNavigatorSearchResultsController.h"
#import "RoomNavigatorTableView.h"
#import "RoomNavigatorTableViewCell.h"

static NSString * const reuseIdentifier = @"RoomNavigatorViewControllerCell";

@interface RoomNavigatorViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, RoomNavigatorSearchResultsControllerDelegate>

@property (strong, nonatomic) RoomNavigatorSearchResultsController *searchResultsController;
@property (strong, nonatomic) RoomNavigatorTableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation RoomNavigatorViewController

- (id)init {
    if (self = [super init]) {
        [self.tableView registerClass:[RoomNavigatorTableViewCell class]
               forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self addChildViewController:self.searchResultsController];
    [self.view insertSubview:self.searchResultsController.view
                aboveSubview:self.tableView];
    [self.searchResultsController didMoveToParentViewController:self];
    [self.view addSubview:self.searchBar];
    [self.searchBar sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setNeedsUpdateConstraints];
}

- (void)setCity:(NSDictionary *)city {
    _city = city;
    _searchBar.placeholder = [NSString stringWithFormat:@"Find rooms in %@...", [_city valueForKey:@"name"]];
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

- (void)showSearchResultsController {
    self.searchResultsController.view.hidden = NO;
}

- (void)hideSearchResultsController {
    self.searchResultsController.view.hidden = YES;
}

- (void)updateViewConstraints {
    if (!self.didSetupConstraints) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.searchBar
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchBar
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchBar
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchBar
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.topLayoutGuide
                                                              attribute:NSLayoutAttributeBottom
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
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultsController.view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.searchBar
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultsController.view
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultsController.view
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchResultsController.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - RoomNavigatorTableView

- (RoomNavigatorTableView *)tableView {
    if (!_tableView) {
        _tableView = [[RoomNavigatorTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
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

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UITableViewHeaderFooterView *)view
       forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
    view.textLabel.textColor = [UIColor lightGrayColor];
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - RoomNavigatorSearchResultsController

- (RoomNavigatorSearchResultsController *)searchResultsController {
    if (!_searchResultsController) {
        _searchResultsController = [[RoomNavigatorSearchResultsController alloc] initWithCityID:self.cityID];
        _searchResultsController.theDelegate = self;
        _searchResultsController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _searchResultsController.view.hidden = YES;
    }
    return _searchResultsController;
}

#pragma mark - RoomNavigatorSearchResultsControllerDelegate

- (void)roomSelected:(NSDictionary *)room
searchResultsController:(RoomNavigatorSearchResultsController *)searchResultsController {
    [self.searchBar setText:@""];
    [self searchBar:self.searchBar
      textDidChange:@""];
    [self.theDelegate roomNavigatorViewController:self
                                       openedRoom:room];
}

#pragma mark - UISearchBar

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _searchBar;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    [self.searchResultsController updateSearchResultsWithQuery:searchText];
    if ([searchText isEqualToString:@""]) {
        [self hideSearchResultsController];
    } else {
        [self showSearchResultsController];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.theDelegate roomNavigatorViewControllerBeganSearch:self];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.theDelegate roomNavigatorViewControllerEndedSearch:self];
}

@end
