//
//  MessagesTableViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/13/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

typedef NS_ENUM(NSInteger, MessagesTableViewControllerMenu) {
    MessagesTableViewControllerMenuCreateNewRoom,
    MessagesTableViewControllerMenuSettings
};

@interface MessagesTableViewController : UITableViewController

- (id)initWithUser:(NSDictionary *)user;
- (void)setMessageHistory:(NSArray *)messages
             lastReadDate:(NSDate *)lastReadDate;
- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user;
- (void)scrollToBottomAnimated:(BOOL)animated;

@end
