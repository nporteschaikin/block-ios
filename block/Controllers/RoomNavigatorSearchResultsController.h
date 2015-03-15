//
//  RoomNavigatorSearchResultsController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/14/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorTableViewController.h"

@class RoomNavigatorSearchResultsController;

@protocol RoomNavigatorSearchResultsControllerDelegate

- (void)roomSelected:(NSDictionary *)room
searchResultsController:(RoomNavigatorSearchResultsController *)searchResultsController;

@end

@interface RoomNavigatorSearchResultsController : RoomNavigatorTableViewController

@property (strong, nonatomic) id<RoomNavigatorSearchResultsControllerDelegate> theDelegate;

- (void)updateSearchResults:(NSArray *)rooms;

@end
