//
//  RoomNavigatorSearchResultsController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/14/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomNavigatorSearchResultsController;

@protocol RoomNavigatorSearchResultsControllerDelegate

- (void)roomSelected:(NSDictionary *)room
searchResultsController:(RoomNavigatorSearchResultsController *)searchResultsController;

@end

@interface RoomNavigatorSearchResultsController : UITableViewController

@property (strong, nonatomic) id<RoomNavigatorSearchResultsControllerDelegate> theDelegate;

- (id)initWithCityID:(NSString *)cityID;

- (void)updateSearchResultsWithQuery:(NSString *)query;

@end
