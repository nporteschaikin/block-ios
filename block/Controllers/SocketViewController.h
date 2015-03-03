//
//  SocketViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/8/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

@interface SocketViewController : UIViewController

- (id)initWithCityID:(NSString *)cityID
      sessionManager:(SessionManager *)sessionManager;

@end
