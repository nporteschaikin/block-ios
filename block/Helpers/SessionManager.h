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

+ (void)withFacebookAccessToken:(NSString *)fbAccessToken
                     onComplete:(void (^)(SessionManager *))onComplete
                         onFail:(void (^)(void))onFail;

+ (void)withSessionToken:(void (^)(SessionManager *))onComplete
                  onFail:(void (^)(void))onFail;

@end
