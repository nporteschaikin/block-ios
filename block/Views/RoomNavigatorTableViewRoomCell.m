//
//  RoomNavigatorTableViewRoomCell.m
//  block
//
//  Created by Noah Portes Chaikin on 3/5/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorTableViewRoomCell.h"

@interface RoomNavigatorTableViewRoomCell ()

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation RoomNavigatorTableViewRoomCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nameLabel];
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView = selectedBackgroundView;
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)setupConstraints {
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
};

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica"
                                                size:14.f];
    }
    return _nameLabel;
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = [NSString stringWithFormat:@"#%@", name];
}

@end
