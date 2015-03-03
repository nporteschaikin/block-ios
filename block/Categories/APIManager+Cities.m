//
//  APIManager+Cities.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "APIManager+Cities.h"
#import "SessionManager.h"
#import "Constants.h"

@implementation APIManager (Cities)

+ (void)getCitiesByLocation:(CLLocation *)location
                 onComplete:(void(^)(NSArray *cities))onComplete {
    [[self sharedManager] GET:IOCitiesAroundLocationEndpoint
               sessionManager:nil
                       params:@{@"lat": [NSString stringWithFormat:@"%f", location.coordinate.latitude],
                                @"lng": [NSString stringWithFormat:@"%f", location.coordinate.longitude]}
                   onComplete:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                       NSArray *cities = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions error:nil];
                       onComplete(cities);
                   }];
}

+ (void)getCityByID:(NSString *)cityID
         onComplete:(void(^)(NSDictionary *city))onComplete {
    [[self sharedManager] GET:[NSString stringWithFormat:IOCityEndpoint, cityID]
               sessionManager:nil
                       params:nil
                   onComplete:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                       onComplete([NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil]);
                   }];
}

@end
