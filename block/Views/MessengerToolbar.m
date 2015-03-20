//
//  MessengerToolbar.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/20/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessengerToolbar.h"

@interface MessengerToolbar () <UITextViewDelegate>

@property (strong, nonatomic) UIView *textView;
@property (strong, nonatomic) UITextView *internalTextView;

@end

@implementation MessengerToolbar

- (id)init {
    if (self = [super init]) {
        [self setupToolbar];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupToolbar];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setTextViewFrame];
}

- (void)setupToolbar {
    [self addSubview:self.textView];
    [self setItems:@[
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                   target:nil
                                                                   action:nil],
                     [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                      style:UIBarButtonItemStyleBordered
                                                     target:nil
                                                     action:nil]
                     ]
          animated:NO];
}

- (UIView *)textView {
    if (!_textView) {
        _textView = [[UIView alloc] initWithFrame:CGRectMake(7, 7, 7, 36)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [_textView addSubview:self.internalTextView];
    }
    return _textView;
}

- (UITextView *)internalTextView {
    if (!_internalTextView) {
        CGRect textViewFrame = self.textView.frame;
        textViewFrame.origin.x = 0;
        textViewFrame.origin.y = 0;
        _internalTextView = [[UITextView alloc] initWithFrame:textViewFrame];
        _internalTextView.delegate = self;
        _internalTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _internalTextView.layer.cornerRadius = 3.0f;
        _internalTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _internalTextView.layer.borderWidth = 1.0f;
        _internalTextView.showsHorizontalScrollIndicator = NO;
    }
    return _internalTextView;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateTextViewFrame];
}

- (void)setTextViewFrame {
    self.textView.frame = CGRectMake(7,
                                     7,
                                     (self.bounds.size.width - 84),
                                     36);
}

- (void)updateTextViewFrame {
    CGRect oInternalTextViewFrame = self.internalTextView.frame;
    CGFloat nInternalTextViewHeight = self.internalTextView.contentSize.height;
    CGRect oTextViewFrame = self.textView.frame;
    CGFloat diff = nInternalTextViewHeight - oInternalTextViewFrame.size.height;
    self.internalTextView.frame = CGRectMake(oInternalTextViewFrame.origin.x,
                                             oInternalTextViewFrame.origin.y,
                                             oInternalTextViewFrame.size.width,
                                             nInternalTextViewHeight);
    self.textView.frame = CGRectMake(oTextViewFrame.origin.x,
                                     oTextViewFrame.origin.y,
                                     oInternalTextViewFrame.size.width,
                                     nInternalTextViewHeight);
    if (diff != 0) {
        CGRect toolbarViewFrame = self.frame;
        toolbarViewFrame.origin.y -= diff;
        toolbarViewFrame.size.height += diff;
        self.frame = toolbarViewFrame;
    }
}

@end
