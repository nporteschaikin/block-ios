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
                  onSuccess:(void(^)(NSArray *cities))onSuccess
                     onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
                    onError:(void(^)(NSError * error))onError {
    [[self sharedManager] GET:IOCitiesAroundLocationEndpoint
               sessionManager:nil
                       params:@{@"lat": [NSString stringWithFormat:@"%f", location.coordinate.latitude],
                                @"lng": [NSString stringWithFormat:@"%f", location.coordinate.longitude]}
                    onSuccess:^(NSURLResponse *response, NSData *data) {
                        NSArray *cities = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:nil];
                        onSuccess(cities);
                    } onFail:onFail onError:onError];
}

+ (void)getCityByID:(NSString *)cityID
          onSuccess:(void(^)(NSDictionary *city))onSuccess
             onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
            onError:(void(^)(NSError * error))onError {
    [[self sharedManager] GET:[NSString stringWithFormat:IOCityEndpoint, cityID]
               sessionManager:nil
                       params:nil
                    onSuccess:^(NSURLResponse *response, NSData *data) {
                        NSDictionary *city = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:nil];
                        onSuccess(city);
                    } onFail:onFail onError:onError];
}

+ (void)searchForRoom:(NSString *)query
         inCityWithID:(NSString *)cityID
            onSuccess:(void(^)(NSArray *rooms))onSuccess
               onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
              onError:(void(^)(NSError * error))onError {
    [[self sharedManager] POST:[NSString stringWithFormat:IOCityRoomSearchEndpoint, cityID]
                sessionManager:nil
                        params:@{@"query": query}
                     onSuccess:^(NSURLResponse *response, NSData *data) {
                         NSArray *rooms = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:nil];
                         onSuccess(rooms);
                     } onFail:onFail onError:onError];
}

+ (void)createRoomInCityWithID:(NSString *)cityID
                          name:(NSString *)name
                   description:(NSString *)description
                     onSuccess:(void(^)(NSDictionary *city))onSuccess
                        onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
                       onError:(void(^)(NSError * error))onError {
    [[self sharedManager] POST:[NSString stringWithFormat:IOCityRoomEndpoint, cityID]
                sessionManager:nil
                        params:@{@"name": name,
                                 @"description": description}
                     onSuccess:^(NSURLResponse *response, NSData *data) {
                         NSDictionary *room = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                                error:nil];
                         onSuccess(room);
                     } onFail:onFail onError:onError];
}

@end
