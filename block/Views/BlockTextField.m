//
//  BlockTextField.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "BlockTextField.h"
#import "Constants.h"

@implementation BlockTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + InputPaddingX, bounds.origin.y + InputPaddingY,
                      bounds.size.width - (InputPaddingX * 2), bounds.size.height - (InputPaddingY * 2));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
