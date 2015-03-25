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

+ (void)searchForRoom:(NSString *)query
         inCityWithID:(NSString *)cityID
           onComplete:(void(^)(NSArray *rooms))onComplete {
    [[self sharedManager] POST:[NSString stringWithFormat:IOCityRoomSearchEndpoint, cityID]
                sessionManager:nil
                        params:@{@"query": query}
                   onComplete:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                       onComplete([NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil]);
                   }];
}

+ (void)createRoomInCityWithID:(NSString *)cityID
                          name:(NSString *)name
                   description:(NSString *)description
                    onComplete:(void(^)(NSDictionary *room))onComplete {
    [[self sharedManager] POST:[NSString stringWithFormat:IOCityRoomEndpoint, cityID]
                sessionManager:nil
                        params:@{@"name": name, @"description": description}
                    onComplete:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        onComplete([NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions error:nil]);
                    }];
}

@end
