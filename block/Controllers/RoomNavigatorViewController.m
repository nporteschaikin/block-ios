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
#import "RoomNavigatorTableViewRoomCell.h"
#import "RoomNavigatorTableViewMenuCell.h"
#import "UIColor+Block.h"

static NSString * const roomReuseIdentifier = @"RoomNavigatorTableViewRoomCell";
static NSString * const menuReuseIdentifier = @"RoomNavigatorTableViewMenuCell";

@interface RoomNavigatorViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, RoomNavigatorSearchResultsControllerDelegate>

@property (strong, nonatomic) RoomNavigatorSearchResultsController *searchResultsController;
@property (strong, nonatomic) RoomNavigatorTableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *createNewRoomButton;
@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic) BOOL isOpeningRoom;

@end

@implementation RoomNavigatorViewController

- (id)init {
    if (self = [super init]) {
        [self.tableView registerClass:[RoomNavigatorTableViewRoomCell class]
               forCellReuseIdentifier:roomReuseIdentifier];
        [self.tableView registerClass:[RoomNavigatorTableViewMenuCell class]
               forCellReuseIdentifier:menuReuseIdentifier];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.rooms.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    UITableViewCell *cell;
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:roomReuseIdentifier];
        [self configureRoomCell:(RoomNavigatorTableViewRoomCell *)cell
                          atRow:row];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:menuReuseIdentifier];
        [self configureMenuCell:(RoomNavigatorTableViewMenuCell *)cell
                          atRow:row];
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)configureRoomCell:(RoomNavigatorTableViewRoomCell *)cell
                    atRow:(NSUInteger)row {
    NSDictionary *room = [self.rooms objectAtIndex:row];
    NSString *name = [room valueForKey:@"name"];
    cell.name = name;
}

- (void)configureMenuCell:(RoomNavigatorTableViewMenuCell *)cell
                    atRow:(NSUInteger)row {
    // foo foo foo
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if (section == 0) {
        [self didSelectRoomCellAtRow:row];
    } else {
        [self didSelectMenuCellAtRow:row];
    }
    [self.searchBar endEditing:YES];
}

- (void)didSelectRoomCellAtRow:(NSUInteger)row {
    self.isOpeningRoom = YES;
    [self.theDelegate roomNavigatorViewController:self
                              selectedRoomAtIndex:row];
}

- (void)didSelectMenuCellAtRow:(NSUInteger)row {
    // do nothing... yet
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    return self.createNewRoomButton;
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
    self.isOpeningRoom = YES;
    [self.searchBar endEditing:YES];
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
    if (!self.isOpeningRoom) {
        [self.theDelegate roomNavigatorViewControllerEndedSearch:self];
    }
    self.isOpeningRoom = NO;
}

#pragma mark - create new room button

- (UIButton *)createNewRoomButton {
    if (!_createNewRoomButton) {
        _createNewRoomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _createNewRoomButton.titleLabel.text = @"Create New Room";
        _createNewRoomButton.backgroundColor = [UIColor blockGreenColor];
        _createNewRoomButton.titleLabel.textColor = [UIColor whiteColor];
        [_createNewRoomButton sizeToFit];
    }
    return _createNewRoomButton;
}

@end
