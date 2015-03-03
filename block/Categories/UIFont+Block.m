//
//  UIFont+Block.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "UIFont+Block.h"

static NSString * const defaultFont = @"Avenir";

@implementation UIFont (Block)

+ (UIFont *)defaultNavigationBarFont {
    return [self fontWithName:defaultFont
                         size:17.0f];
}

+ (UIFont *)defaultTabBarButtonFont {
    return [self fontWithName:defaultFont
                         size:10.0f];
}

+ (UIFont *)defaultBarButtonFont {
    return [self fontWithName:defaultFont
                         size:17.0f];
}

+ (UIFont *)defaultTextViewFont {
    return [self fontWithName:defaultFont
                         size:14.0f];
}

+ (UIFont *)defaultTextFieldFont {
    return [self fontWithName:defaultFont
                         size:14.0f];
}

+ (UIFont *)defaultLabelFont {
    return [self fontWithName:defaultFont
                         size:12.0f];
}

@end
