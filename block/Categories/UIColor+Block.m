//
//  UIColor+Block.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/19/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "UIColor+Block.h"

@implementation UIColor (Block)

+ (UIColor *)blockGreenColor {
    return [UIColor colorWithRed:0
                           green:1
                            blue:0.8
                           alpha:1];
}

+ (UIColor *)blockGreenColorAlpha:(float)alpha {
    return [UIColor colorWithRed:0
                           green:1
                            blue:0.8
                           alpha:alpha];
}

+ (UIColor *)blockGreyColor {
    return [UIColor colorWithRed:0.259
                           green:0.259
                            blue:0.259
                           alpha:1];
}

@end
