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
#import "UIColor+Block.h"

@interface LoginViewController () <FBLoginViewDelegate>

@property (strong, nonatomic) FBLoginView *loginView;
@property (strong, nonatomic) UIButton *loginFacebookButton;
@property (strong, nonatomic) NSLayoutConstraint *loginFacebookButtonBottomConstraint;
@property (strong, nonatomic) UIImageView *logoView;

@end

@implementation LoginViewController

- (id)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.logoView];
        [self.view addSubview:self.loginFacebookButton];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    [self.view addConstraint:self.loginFacebookButtonBottomConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginFacebookButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginFacebookButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:-self.loginFacebookButton.frame.size.height]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
}

- (UIImageView *)logoView {
    if (!_logoView) {
        UIImage *image = [UIImage imageNamed:@"LaunchLogo"];
        _logoView = [[UIImageView alloc] initWithImage:image];
        _logoView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoView.layer.cornerRadius = image.size.width / 2;
        _logoView.layer.masksToBounds = YES;
        _logoView.alpha = 0.0f;
    }
    return _logoView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // animate logo
    [UIView animateWithDuration:1
                     animations:^{
                         self.logoView.alpha = 1;
                     }];
}

- (UIButton *)loginFacebookButton {
    if (!_loginFacebookButton) {
        _loginFacebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginFacebookButton.backgroundColor = [UIColor colorWithRed:0.231
                                                               green:0.349
                                                                blue:0.596
                                                               alpha:1];
        _loginFacebookButton.translatesAutoresizingMaskIntoConstraints = NO;
        _loginFacebookButton.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        [_loginFacebookButton setTitle:@"Sign in with Facebook"
                              forState:UIControlStateNormal];
        [_loginFacebookButton addTarget:self action:@selector(signInWithFacebook)
                       forControlEvents:UIControlEventTouchDown];
        [_loginFacebookButton sizeToFit];
    }
    return _loginFacebookButton;
}

- (void)signInWithFacebook {
    [FBSession openActiveSessionWithReadPermissions:@[]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      if (FBSession.activeSession.state == FBSessionStateOpen) {
                                          [self signedInWithFacebook];
                                      }
                                  }];
}

- (void)signedInWithFacebook {
    FBAccessTokenData *accessTokenData = [[FBSession activeSession] accessTokenData];
    NSString *fbAccessToken = [accessTokenData accessToken];
    [SessionManager withFacebookAccessToken:fbAccessToken
                                  onSuccess:^(SessionManager *sessionManager) {
                                      [self.delegate loginViewController:self
                                              didLogInWithSessionManager:sessionManager];
                                  } onFail:^(NSURLResponse *response, NSData *data) {
                                      // failed?  this makes no sense!
                                  } onError:^(NSError *error) {
                                      // no internet connection.
                                  }];
}

- (void)showLoginFacebookButton {
    self.loginFacebookButtonBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideLoginFacebookButton {
    self.loginFacebookButtonBottomConstraint.constant = self.loginFacebookButton.frame.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (NSLayoutConstraint *)loginFacebookButtonBottomConstraint {
    if (!_loginFacebookButtonBottomConstraint) {
        _loginFacebookButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.loginFacebookButton
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1
                                                                             constant:self.loginFacebookButton.frame.size.height];
    }
    return _loginFacebookButtonBottomConstraint;
}

@end

