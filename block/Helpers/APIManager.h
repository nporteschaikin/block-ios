//
//  APIManager.h
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"

@interface APIManager : NSObject

+ (APIManager *)sharedManager;

- (void)GET:(NSString *)path
sessionManager:(SessionManager *)sessionManager
     params:(NSDictionary *)params
  onSuccess:(void(^)(NSURLResponse *response, NSData *data))onSuccess
     onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
    onError:(void(^)(NSError *error))onError;

- (void)POST:(NSString *)path
sessionManager:(SessionManager *)sessionManager
      params:(NSDictionary *)params
   onSuccess:(void(^)(NSURLResponse *response, NSData *data))onSuccess
      onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
     onError:(void(^)(NSError *error))onError;

@end
