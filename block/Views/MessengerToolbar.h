//
//  MessengerToolbar.h
//  bloc
//
//  Created by Noah Portes Chaikin on 3/20/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessengerToolbar;

@protocol MessengerToolbarDelegate

- (void)messengerToolbar:(MessengerToolbar *)messengerToolbar
         askedToSendText:(NSString *)text;

- (void)messengerToolbar:(MessengerToolbar *)messengerToolbar
         didChangeHeight:(CGFloat)diff;

@end

@interface MessengerToolbar : UIView

@property (strong, nonatomic) id<MessengerToolbarDelegate> theDelegate;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;

@end
