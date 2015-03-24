//
//  MessageTableViewCell.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "NSDate+TimeAgo.h"
#import "UIColor+Block.h"

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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.bounds);
    
    // set background color
    if (self.isCurrentUser == YES) {
        self.backgroundColor = [UIColor blockGreenColorAlpha:0.05];
    } else if (self.isUnread == YES) {
        self.backgroundColor = [UIColor blockGreenColorAlpha:0.5];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void) updateConstraints {
    if (!self.didSetupConstraints) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeAgoLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:14]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeAgoLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.userNameLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:5]];
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
                                                                      constant:-14]];
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
                                                                      constant:-10]];
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
        _userNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold"
                                              size:14.f];
    }
    return _userNameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont fontWithName:@"Helvetica"
                                             size:14.f];
    }
    return _messageLabel;
}

- (UILabel *)timeAgoLabel {
    if (!_timeAgoLabel) {
        _timeAgoLabel = [[UILabel alloc] init];
        _timeAgoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeAgoLabel.textColor = [UIColor grayColor];
        _timeAgoLabel.numberOfLines = 1;
        _timeAgoLabel.font = [UIFont fontWithName:@"Helvetica"
                                             size:14.f];
    }
    return _timeAgoLabel;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameLabel.text = userName;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.messageLabel.text = message;
}

- (void)setCreatedAt:(NSDate *)createdAt {
    _createdAt = createdAt;
    self.timeAgoLabel.text = [createdAt timeAgo];
}

@end
