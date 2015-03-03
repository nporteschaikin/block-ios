//
//  MessageTableViewCell.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@property (nonatomic, readwrite) BOOL didSetupConstraints;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *timeAgoLabel;

@end

@implementation MessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.timeAgoLabel];
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = selectedBackgroundView;
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.userNameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.bounds);
    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.bounds);
}

- (void) updateConstraints {
    if (!self.didSetupConstraints) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:17]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeAgoLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:17]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:17]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.userNameLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.userNameLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:-17]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeAgoLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:-17]];
    }
    [super updateConstraints];
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _userNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _userNameLabel.numberOfLines = 1;
    }
    return _userNameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)timeAgoLabel {
    if (!_timeAgoLabel) {
        _timeAgoLabel = [[UILabel alloc] init];
        _timeAgoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeAgoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _timeAgoLabel.textColor = [UIColor grayColor];
        _timeAgoLabel.numberOfLines = 1;
    }
    return _timeAgoLabel;
}

- (void)setUserName:(NSString *)userName {
    self.userNameLabel.text = userName;
}

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;
}

@end
