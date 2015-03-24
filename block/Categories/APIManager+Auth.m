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
                    onComplete:(void(^)(NSDictionary *result))onComplete
                        onFail:(void (^)(void))onFail {
    [[self sharedManager] POST:IOAuthEndpoint sessionManager:nil params:params
                    onComplete:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                        if (statusCode != 200) {
                            onFail();
                        } else {
                            onComplete([NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:nil]);
                        };
                    }];
}

@end
