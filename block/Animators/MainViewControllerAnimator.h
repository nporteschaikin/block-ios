//
//  MainViewControllerAnimator.h
//  bloc
//
//  Created by Noah Portes Chaikin on 3/21/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewControllerAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (id)initWithMessengerViewControllers:(NSArray *)messengerViewControllers
                    transitionDuration:(float)transitionDuration;

@end
