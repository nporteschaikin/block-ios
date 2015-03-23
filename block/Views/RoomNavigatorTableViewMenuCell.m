//
//  RoomNavigatorTableViewMenuCell.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/22/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorTableViewMenuCell.h"

@implementation RoomNavigatorTableViewMenuCell

- (id)init {
    if (self = [super init]) {
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:17]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:-17]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:-10]];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

@end
