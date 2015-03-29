//
//  MessengerToolbar.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/20/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessengerToolbar.h"

@interface MessengerToolbar () <UITextViewDelegate>

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) CGFloat textViewContentHeight;

@end

@implementation MessengerToolbar

- (id)init {
    if (self = [super init]) {
        [self setupToolbar];
        [self setupConstraints];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupToolbar];
        [self setupConstraints];
    }
    return self;
}

- (void)setupToolbar {
    // add subviews
    [self addSubview:self.textView];
    [self addSubview:self.sendButton];
    // set background color
    self.backgroundColor = [UIColor colorWithRed:0.945
                                           green:0.945
                                            blue:0.945
                                           alpha:1];
}

- (void)setupConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:7]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:7]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-7]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.sendButton
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-7]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sendButton
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-7]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sendButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:self.heightConstraint];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5.0f;
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.borderColor = [[UIColor grayColor] CGColor];
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_sendButton setTitle:@"Send"
                     forState:UIControlStateNormal];
        [_sendButton addTarget:self
                        action:@selector(sendButtonTouchDown:)
              forControlEvents:UIControlEventTouchDown];
        [_sendButton sizeToFit];
    }
    return _sendButton;
}

- (NSLayoutConstraint *)heightConstraint {
    if (!_heightConstraint) {
        _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:50];
    }
    return _heightConstraint;
}

- (void)sendButtonTouchDown:(id)sender {
    [self.theDelegate messengerToolbar:self
                       askedToSendText:self.textView.text];
    // remove text
    self.textView.text = nil;
    [self.textView resignFirstResponder];
    [self textViewDidChange:self.textView];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (!self.textViewContentHeight) {
        self.textViewContentHeight = self.textView.contentSize.height;
    } else {
        CGFloat oTextViewHeight = self.textViewContentHeight;
        CGFloat nTextViewHeight = self.textView.contentSize.height;
        CGFloat diff = nTextViewHeight - oTextViewHeight;
        self.textViewContentHeight = nTextViewHeight;
        if (diff != 0) {
            self.heightConstraint.constant += diff;
            [self.textView setContentOffset:CGPointZero
                                   animated:NO];
        }
        [self.theDelegate messengerToolbar:self
                           didChangeHeight:diff];
    }
}

@end
