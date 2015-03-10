//
//  LoginViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "SessionManager.h"

@interface LoginViewController () <FBLoginViewDelegate>
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFacebookLoginView];
}

- (void)setFacebookLoginView {
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile",
                                                                            @"email",
                                                                            @"user_friends"]];
    loginView.center = self.view.center;
    loginView.delegate = self;
    [self.view addSubview:loginView];
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    [SessionManager withFacebookAccessToken:fbAccessToken onComplete:^(SessionManager *sessionManager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate loginViewController:self
                    didLogInWithSessionManager:sessionManager];
        });
    } onFail:nil];
}

@end

