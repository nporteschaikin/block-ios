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

@property (strong, nonatomic) FBLoginView *loginView;

@end

@implementation LoginViewController

- (id)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.loginView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
}

- (FBLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile",
                                                                    @"email",
                                                                    @"user_friends"]];
        _loginView.delegate = self;
        _loginView.center = self.view.center;
    }
    return _loginView;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    [SessionManager withFacebookAccessToken:fbAccessToken
                                 onComplete:^(SessionManager *sessionManager) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.delegate loginViewController:self
                                                didLogInWithSessionManager:sessionManager];
                                    });
                                 } onFail:nil];
}

@end

