//
//  NSDate+ISO8601.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/17/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)

+ (NSDate *)dateWithISO8601:(NSString *)ISO8601date {
    NSString *dateString = [ISO8601date substringToIndex:(ISO8601date.length - 5)];
    NSString *dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDateFormatter *gmtFormatter = [[NSDateFormatter alloc] init];
    gmtFormatter.dateFormat = dateFormat;
    gmtFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *gmtDate = [gmtFormatter dateFromString:dateString];
    NSString *gmtString = [gmtFormatter stringFromDate:gmtDate];
    
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    localFormatter.dateFormat = dateFormat;
    localFormatter.timeZone = [NSTimeZone localTimeZone];
    return [localFormatter dateFromString:gmtString];
}

@end
