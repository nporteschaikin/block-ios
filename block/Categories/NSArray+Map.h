//
//  NSArray+Map.h
//  block
//
//  Created by Noah Portes Chaikin on 3/5/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)map:(id (^)(id obj, NSUInteger idx))block;

@end
