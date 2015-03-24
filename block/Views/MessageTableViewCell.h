//
//  MessageTableViewCell.h
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *createdAt;
@property (nonatomic) BOOL isCurrentUser;
@property (nonatomic) BOOL isUnread;

@end
