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

- (void)handleMessengerViewControllerRightBarButtonItem:(MessengerViewController *)messengerViewController;

- (void)messengerViewController:(MessengerViewController *)messengerViewController
                    messageSent:(NSString *)message;

- (void)messengerViewControllerSwipedLeft:(MessengerViewController *)messengerViewController;

- (void)messengerViewControllerSwipedRight:(MessengerViewController *)messengerViewController;

- (void)messengerViewControllerTableViewTapped:(MessengerViewController *)messengerViewController;

@end

@interface MessengerViewController : UIViewController

@property (strong, nonatomic) id<MessengerViewControllerDelegate> theDelegate;
@property (strong, nonatomic, readonly) NSDictionary *room;

- (id)initWithRoom:(NSDictionary *)room;
- (void)setMessageHistory:(NSArray *)messages;
- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user;

@end
