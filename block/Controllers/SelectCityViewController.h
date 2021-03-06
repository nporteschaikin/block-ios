//
//  SelectCityViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

@interface SelectCityViewController : UIViewController

- (id)initWithCities:(NSArray *)cities
      sessionManager:(SessionManager *)sessionManager;

@end
