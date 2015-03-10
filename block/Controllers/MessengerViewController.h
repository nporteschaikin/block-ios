//
//  MessengerViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/2/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessengerViewController;

@protocol MessengerViewControllerDelegate

- (void)handleMessengerViewControllerLeftBarButtonItem:(MessengerViewController *)messengerViewController;

- (void)messengerViewController:(MessengerViewController *)messengerViewController
                    messageSent:(NSString *)message;

- (void)messengerViewControllerAskedToLeave:(MessengerViewController *)messengerViewController;

@end

@interface MessengerViewController : UIViewController

@property (strong, nonatomic) id<MessengerViewControllerDelegate> theDelegate;
@property (strong, nonatomic, readonly) NSDictionary *room;

- (id)initWithRoom:(NSDictionary *)room;
- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user;
- (void)addMessages:(NSArray *)messages;

@end
