//
//  SessionManager.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "SessionManager.h"
#import "APIManager+Auth.h"
#import "Constants.h"

static SessionManager *activeSession;

@interface SessionManager ()
@property (strong, nonatomic, readwrite) NSString *sessionToken;
@property (strong, nonatomic, readwrite) NSDictionary *user;
@end

@implementation SessionManager

+ (void)withFacebookAccessToken:(NSString *)fbAccessToken
                     onComplete:(void (^)(SessionManager *))onComplete
                         onFail:(void (^)(void))onFail {
    [self withParams:@{@"fbAccessToken": fbAccessToken}
          onComplete:onComplete
              onFail:onFail];
}

+ (void)withSessionToken:(void (^)(SessionManager *))onComplete
                  onFail:(void (^)(void))onFail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [defaults objectForKey:SessionTokenUserDefaultsKey];
    if (sessionToken) {
        [self withParams:@{@"sessionToken": sessionToken}
              onComplete:onComplete
                  onFail:onFail];
    } else {
        onFail();
    }
}

+ (void)withParams:(NSDictionary *)params
        onComplete:(void (^)(SessionManager *))onComplete
            onFail:(void (^)(void))onFail {
    [APIManager getAuthTokenWithParams:params
                            onComplete:^(NSDictionary *result) {
                                NSLog(@"%@", result);
                                NSString *sessionToken = [result objectForKey:@"sessionToken"];
                                NSDictionary *user = [result objectForKey:@"user"];
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setObject:sessionToken forKey:SessionTokenUserDefaultsKey];
                                onComplete([[SessionManager alloc] initWithSessionToken:sessionToken
                                                                                   user:user]);
                            } onFail:onFail];
}

- (id)initWithSessionToken:(NSString *)sessionToken
                      user:(NSDictionary *)user {
    if (self = [super init]) {
        self.sessionToken = sessionToken;
        self.user = user;
    }
    return self;
}

@end