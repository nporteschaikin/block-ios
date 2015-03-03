//
//  APIManager+Cities.h
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "APIManager.h"
#import <CoreLocation/CoreLocation.h>

@interface APIManager (Cities)

+ (void)getCitiesByLocation:(CLLocation *)location
                 onComplete:(void(^)(NSArray *cities))onComplete;

+ (void)getCityByID:(NSString *)cityID
         onComplete:(void(^)(NSDictionary *city))onComplete;

@end
