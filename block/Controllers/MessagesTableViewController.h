//
//  MessagesTableViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/13/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesTableViewController : UITableViewController

- (void)setMessageHistory:(NSArray *)messages;
- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user;
- (void)scrollToBottomAnimated:(BOOL)animated;

@end
