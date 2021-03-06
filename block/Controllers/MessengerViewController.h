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

- (void)messengerViewControllerTableViewTapped:(MessengerViewController *)messengerViewController;
- (void)messengerViewControllerTableViewSwipedLeft:(MessengerViewController *)messengerViewController;
- (void)messengerViewControllerTableViewSwipedRight:(MessengerViewController *)messengerViewController;

@end

@interface MessengerViewController : UIViewController

@property (strong, nonatomic) id<MessengerViewControllerDelegate> theDelegate;
@property (strong, nonatomic) NSDictionary *room;

- (id)initWithRoom:(NSDictionary *)room
              user:(NSDictionary *)user;
- (void)setMessageHistory:(NSArray *)messages
             lastReadDate:(NSDate *)lastReadDate;
- (void)addMessage:(NSDictionary *)message
            byUser:(NSDictionary *)user;

@end
