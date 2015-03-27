//
//  APIManager+Auth.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "APIManager+Auth.h"
#import "Constants.h"

@implementation APIManager (Auth)

+ (void)getAuthTokenWithParams:(NSDictionary *)params
                     onSuccess:(void(^)(NSDictionary *city))onSuccess
                        onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
                       onError:(void(^)(NSError *error))onError {
    [[self sharedManager] POST:IOAuthEndpoint
                sessionManager:nil
                        params:params
                     onSuccess:^(NSURLResponse *response, NSData *data) {
                         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions
                                                                                  error:nil];
                         onSuccess(result);
                     } onFail:onFail onError:onError];
}

@end
