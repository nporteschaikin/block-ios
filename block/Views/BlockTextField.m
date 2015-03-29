//
//  BlockTextField.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/25/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "BlockTextField.h"

static CGFloat const inputPaddingX = 17.f;
static CGFloat const inputPaddingY = 17.f;

@implementation BlockTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + inputPaddingX, bounds.origin.y + inputPaddingY,
                      bounds.size.width - (inputPaddingX * 2), bounds.size.height - (inputPaddingY * 2));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
