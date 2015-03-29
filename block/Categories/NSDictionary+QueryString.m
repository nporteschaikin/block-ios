//
//  NSDictionary+QueryString.m
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "NSDictionary+QueryString.h"
@implementation NSDictionary (QueryString)

NSString *keyValueString(NSString *key, id object) {
    NSMutableArray *components = [NSMutableArray array];
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *newArray = [NSMutableArray array];
        unsigned long count = 0;
        for (id obj in object) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                for (NSString *k in obj) {
                    if (key != nil) {
                        [newArray addObject:[NSString stringWithFormat:@"%@[%lu][%@]=%@", key, count, k, keyValueString(nil, [obj valueForKey:k])]];
                    }
                }
            } else {
                [newArray addObject:[NSString stringWithFormat:@"%@[%lu]=%@", key, count, obj]];
            }
            [components addObject:[newArray componentsJoinedByString:@"&"]];
            count++;
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        for (NSString *k in object) {
            id obj = [(NSDictionary *)object valueForKey:k];
            [components addObject:[NSString stringWithFormat:@"%@=%@", key, keyValueString(k, obj)]];
        }
    } else {
        if (key != nil) {
            [components addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSString *)object stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        } else {
            [components addObject:[NSString stringWithFormat:@"%@", [(NSString *)object stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    return [components componentsJoinedByString:@"&"];
}

NSString *keyValueArrayString(NSString *key, NSArray *object) {
    NSMutableArray *newArray = [NSMutableArray array];
    for (id obj in object) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            for (NSString *k in obj) {
                [newArray addObject:[NSString stringWithFormat:@"%@[]%@", key, keyValueString(k, [obj valueForKey:k])]];
            }
        } else {
            [newArray addObject:[NSString stringWithFormat:@"%@[]=%@", key, obj]];
        }
    }
    return [newArray componentsJoinedByString:@"&"];
}

- (NSString *)queryString {
    NSMutableString *queryString = [[NSMutableString alloc] init];
    NSArray *keys = [self allKeys];
    if (keys.count > 0) {
        NSUInteger count = 0;
        for (id key in keys) {
            id value = [self objectForKey:key];
            if (value != nil) {
                [queryString appendString:keyValueString(key, value)];
            }
            count++;
            if (count < keys.count) {
                [queryString appendFormat:@"&"];
            }
        }
    }
    return queryString;
}

@end
