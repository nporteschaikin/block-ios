//
//  SessionManager.h
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject

@property (strong, nonatomic, readonly) NSString *sessionToken;
@property (strong, nonatomic, readonly) NSDictionary *user;

+ (void)withFacebookAccessToken:(NSString *)fbAccessToken
                      onSuccess:(void (^)(SessionManager *sessionManager))onSuccess
                         onFail:(void (^)(NSURLResponse *response, NSData *data))onFail
                        onError:(void (^)(NSError *error))onError;

+ (void)withSessionTokenOnSuccess:(void (^)(SessionManager *sessionManager))onSuccess
                           onFail:(void (^)(NSURLResponse *response, NSData *data))onFail
                          onError:(void (^)(NSError *error))onError;

@end
