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
       didChangeHeightBy:(CGFloat)diff;

@end

@interface MessengerToolbar : UIToolbar

@property (strong, nonatomic) id<MessengerToolbarDelegate> theDelegate;

@end
