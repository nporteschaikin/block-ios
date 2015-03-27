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
                      onSuccess:(void (^)(SessionManager *sessionManager))onSuccess
                         onFail:(void (^)(NSURLResponse *response, NSData *data))onFail
                        onError:(void (^)(NSError *error))onError {
    [self withParams:@{@"fbAccessToken": fbAccessToken}
           onSuccess:onSuccess
              onFail:onFail
             onError:onError];
}

+ (void)withSessionTokenOnSuccess:(void (^)(SessionManager *sessionManager))onSuccess
                           onFail:(void (^)(NSURLResponse *response, NSData *data))onFail
                          onError:(void (^)(NSError *error))onError {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [defaults objectForKey:SessionTokenUserDefaultsKey];
    if (sessionToken) {
        [self withParams:@{@"sessionToken": sessionToken}
               onSuccess:onSuccess
                  onFail:onFail
                 onError:onError];
    } else {
        onFail(nil, nil);
    }
}

+ (void)withParams:(NSDictionary *)params
         onSuccess:(void (^)(SessionManager *sessionManager))onSuccess
            onFail:(void (^)(NSURLResponse *response, NSData *data))onFail
           onError:(void (^)(NSError *error))onError {
    [APIManager getAuthTokenWithParams:params
                             onSuccess:^(NSDictionary *result) {
                                 NSString *sessionToken = [result objectForKey:@"sessionToken"];
                                 NSDictionary *user = [result objectForKey:@"user"];
                                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                 [defaults setObject:sessionToken forKey:SessionTokenUserDefaultsKey];
                                 SessionManager *sessionManager = [[SessionManager alloc] initWithSessionToken:sessionToken
                                                                                                          user:user];
                                 onSuccess(sessionManager);
                             } onFail:onFail onError:onError];
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