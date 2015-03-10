//
//  FindingCityViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

@class FindingCityViewController;

@protocol FindingCityViewControllerDelegate

- (void)findingCityViewController:(FindingCityViewController *)findingCityViewController
                didFindSingleCity:(NSDictionary *)city;

- (void)findingCityViewController:(FindingCityViewController *)findingCityViewController
            didFindMultipleCities:(NSArray *)cities;

@end

@interface FindingCityViewController : UIViewController

@property (strong, nonatomic) id<FindingCityViewControllerDelegate> delegate;

- (id)initWithSessionManager:(SessionManager *)sessionManager;

@end
