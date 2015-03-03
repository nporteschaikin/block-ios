//
//  RoomNavigatorViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorViewController.h"
#import "RoomNavigatorTableViewCell.h"

static NSString * const reuseIdentifier = @"RoomNavigatorTableViewCell";

@interface RoomNavigatorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *city;
@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic, readonly) NSArray *unopenedRooms;
@property (strong, nonatomic) NSMutableArray *openRooms;

@end

@implementation RoomNavigatorViewController

- (id)initWithCity:(NSDictionary *)city
             rooms:(NSArray *)rooms
         openRooms:(NSMutableArray *)openRooms {
    if (self = [self init]) {
        self.city = city;
        self.rooms = rooms;
        self.openRooms = openRooms;
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor grayColor];
        self.definesPresentationContext = YES;
    }
    return self;
}

- (NSArray *)unopenedRooms {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.rooms];
    [mutableArray removeObjectsInArray:self.openRooms];
    return mutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[RoomNavigatorTableViewCell class]
           forCellReuseIdentifier:reuseIdentifier];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Open";
        default:
            return [NSString stringWithFormat:@"In %@", [self.city objectForKey:@"name"]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.openRooms.count;
        default:
            return self.unopenedRooms.count;
    }
}

- (RoomNavigatorTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomNavigatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSDictionary *room = (indexPath.section == 0) ? [self.openRooms objectAtIndex:indexPath.row]
        : [self.unopenedRooms objectAtIndex:indexPath.row];
    [cell setName:[room objectForKey:@"name"]];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    if (indexPath.section == 0) {
        [self.theDelegate roomNavigatorViewController:self
                                  selectedRoomAtIndex:index];
    } else {
        NSDictionary *room = [self.unopenedRooms objectAtIndex:index];
        NSUInteger roomsIndex = [self.rooms indexOfObject:room];
        [self.theDelegate roomNavigatorViewController:self
                                    openedRoomAtIndex:roomsIndex];
    }
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

@end
