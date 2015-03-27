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
                  onSuccess:(void(^)(NSArray *cities))onSuccess
                     onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
                    onError:(void(^)(NSError * error))onError;

+ (void)getCityByID:(NSString *)cityID
          onSuccess:(void(^)(NSDictionary *city))onSuccess
             onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
            onError:(void(^)(NSError * error))onError;

+ (void)searchForRoom:(NSString *)query
         inCityWithID:(NSString *)cityID
            onSuccess:(void(^)(NSArray *rooms))onSuccess
               onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
              onError:(void(^)(NSError * error))onError;

+ (void)createRoomInCityWithID:(NSString *)cityID
                          name:(NSString *)name
                   description:(NSString *)description
                     onSuccess:(void(^)(NSDictionary *room))onSuccess
                        onFail:(void(^)(NSURLResponse *response, NSData *data))onFail
                       onError:(void(^)(NSError * error))onError;

@end
