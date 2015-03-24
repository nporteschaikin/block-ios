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
                    onComplete:(void(^)(NSDictionary *result))onComplete
                        onFail:(void (^)(void))onFail;

@end
