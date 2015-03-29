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
#import "APIManager+Cities.h"
#import "UIColor+Block.h"
#import "UIFont+Block.h"

static NSString * const roomReuseIdentifier = @"RoomNavigatorTableViewRoomCell";

@interface RoomNavigatorViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, RoomNavigatorSearchResultsControllerDelegate>

@property (strong, nonatomic) NSDictionary *city;
@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) NSArray *popularRooms;
@property (strong, nonatomic) RoomNavigatorSearchResultsController *searchResultsController;
@property (strong, nonatomic) RoomNavigatorTableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *createNewRoomButton;

@end

@implementation RoomNavigatorViewController

- (id)initWithCityID:(NSString *)cityID
                city:(NSDictionary *)city
               rooms:(NSArray *)rooms {
    if (self = [super init]) {
        self.cityID = cityID;
        self.city = city;
        self.rooms = rooms;
        [self.tableView registerClass:[RoomNavigatorTableViewRoomCell class]
               forCellReuseIdentifier:roomReuseIdentifier];
        [self.view addSubview:self.tableView];
        [self addChildViewController:self.searchResultsController];
        [self.view insertSubview:self.searchResultsController.view
                    aboveSubview:self.tableView];
        [self.searchResultsController didMoveToParentViewController:self];
        [self.view addSubview:self.searchBar];
        [self.view addSubview:self.createNewRoomButton];
        [self.searchBar sizeToFit];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set city name in search bar placeholder
    NSString *cityName = [self.city valueForKey:@"name"];
    self.searchBar.placeholder = [NSString stringWithFormat:@"Find rooms in %@...", cityName];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // get popular rooms
    [self getPopularRooms];
}

- (void)getPopularRooms {
    [APIManager getPopularRoomsInCityWithID:self.cityID
                                  onSuccess:^(NSArray *rooms) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          self.popularRooms = rooms;
                                          [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                                                        withRowAnimation:UITableViewRowAnimationNone];
                                      });
                                  } onFail:nil onError:nil];
}

- (void)openSessionRooms {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)openRoomAtIndex:(NSUInteger)index {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)leaveRoomAtIndex:(NSUInteger)index {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showSearchResultsController {
    self.searchResultsController.view.hidden = NO;
}

- (void)hideSearchResultsController {
    self.searchResultsController.view.hidden = YES;
}

- (void)setupConstraints {
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
                                                             toItem:self.createNewRoomButton
                                                          attribute:NSLayoutAttributeTop
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
                                                             toItem:self.createNewRoomButton
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.createNewRoomButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.createNewRoomButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.createNewRoomButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
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
    return self.popularRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomNavigatorTableViewRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:roomReuseIdentifier];
    [self configureCell:cell
            atIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)configureCell:(RoomNavigatorTableViewRoomCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *room;
    if (indexPath.section == 0) {
        room = [self.rooms objectAtIndex:indexPath.row];
    } else {
        room = [self.popularRooms objectAtIndex:indexPath.row];
    }
    NSString *name = [room valueForKey:@"name"];
    cell.name = name;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if (section == 0) {
        [self didSelectOpenRoomCellAtRow:row];
    } else {
        [self didSelectPopularRoomCellAtRow:row];
    }
    [self.searchBar endEditing:YES];
}

- (void)didSelectOpenRoomCellAtRow:(NSUInteger)row {
    [self.theDelegate roomNavigatorViewController:self
                              selectedRoomAtIndex:row];
}

- (void)didSelectPopularRoomCellAtRow:(NSUInteger)row {
    NSDictionary *room = [self.popularRooms objectAtIndex:row];
    [self.theDelegate roomNavigatorViewController:self
                              openedRoom:room];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [NSString stringWithFormat:@"Popular in %@", [self.city objectForKey:@"name"]];
    }
    return @"Open";
}

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UITableViewHeaderFooterView *)view
       forSection:(NSInteger)section {
    view.textLabel.textColor = [UIColor lightGrayColor];
    view.textLabel.font = [UIFont defaultLabelFont];
    view.tintColor = [UIColor blockGreyColor];
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

#pragma mark - create new room button

- (UIButton *)createNewRoomButton {
    if (!_createNewRoomButton) {
        _createNewRoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createNewRoomButton.titleLabel.font = [UIFont fontWithName:@"Arial"
                                                               size:14.f];
        _createNewRoomButton.titleLabel.numberOfLines = 1;
        _createNewRoomButton.contentEdgeInsets = UIEdgeInsetsMake(12, 17, 12, 12);
        _createNewRoomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _createNewRoomButton.translatesAutoresizingMaskIntoConstraints = NO;
        _createNewRoomButton.backgroundColor = [UIColor blockGreenColor];
        [_createNewRoomButton setTitle:@"+ Create New Room"
                              forState:UIControlStateNormal];
        [_createNewRoomButton setTitleColor:[UIColor blockGreyColor]
                                   forState:UIControlStateNormal];
        [_createNewRoomButton setTitleColor:[UIColor blockGreenColorAlpha:0.5]
                                   forState:UIControlStateSelected];
        [_createNewRoomButton setTitleColor:[UIColor blockGreenColorAlpha:0.5]
                                   forState:UIControlStateHighlighted];
        [_createNewRoomButton addTarget:self
                                 action:@selector(handleCreateNewRoomButtonTouchDown:)
                       forControlEvents:UIControlEventTouchDown];
        [_createNewRoomButton sizeToFit];
    }
    return _createNewRoomButton;
}

- (void)handleCreateNewRoomButtonTouchDown:(id)sender {
    [self.theDelegate roomNavigatorViewController:self
                                           action:RoomNavigatorViewControllerActionCreateNewRoom];
    [self.searchBar endEditing:YES];
}

@end
