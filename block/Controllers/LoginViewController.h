//
//  LoginViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate

- (void)loginViewController:(LoginViewController *)loginViewController
 didLogInWithSessionManager:(SessionManager *)sessionManager;

@end

@interface LoginViewController : UIViewController

@property (strong, nonatomic) id<LoginViewControllerDelegate> delegate;

@end
