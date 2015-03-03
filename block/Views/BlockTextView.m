//
//  BlockTextView.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "BlockTextView.h"
#import "Constants.h"

@implementation BlockTextView

- (id)init {
    if (self = [super init]) {
        [self addSubview:self.placeholderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChange)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        self.textContainerInset = UIEdgeInsetsMake(InputPaddingY, InputPaddingX, InputPaddingY, InputPaddingX);
    }
    return self;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    return _placeholderLabel;
}

- (void)textViewDidChange {
    if (self.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (id)initWithBorderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor {
    if (self = [super init]) {
        self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
        self.layer.borderColor = borderColor ? [borderColor CGColor] : [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = borderWidth;
    }
    return self;
}

@end
