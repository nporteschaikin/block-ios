//
//  APIManager+Auth.h
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "APIManager.h"

@interface APIManager (Auth)

+ (void)getAuthTokenWithParams:(NSDictionary *)params
                     onSuccess:(void(^)(NSDictionary *city))onSuccess
                        onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
                       onError:(void(^)(NSError *error))onError;

@end
