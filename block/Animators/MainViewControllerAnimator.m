//
//  MainViewControllerAnimator.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/21/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MainViewControllerAnimator.h"
#import "MessengerViewController.h"

@interface MainViewControllerAnimator ()

@property (strong, nonatomic) NSArray *messengerViewControllers;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic) float transitionDuration;

@end

@implementation MainViewControllerAnimator

- (id)initWithMessengerViewControllers:(NSArray *)messengerViewControllers
                    transitionDuration:(float)transitionDuration {
    if (self = [super init]) {
        self.messengerViewControllers = messengerViewControllers;
        self.transitionDuration = transitionDuration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    BOOL betweenMessengerViewControllers = [fromViewController isKindOfClass:[MessengerViewController class]]
        && [toViewController isKindOfClass:[MessengerViewController class]];
    CGFloat toStart;
    CGFloat fromEnd;
    if (betweenMessengerViewControllers) {
        NSUInteger fromIndex = [self.messengerViewControllers indexOfObject:fromViewController];
        NSUInteger toIndex = [self.messengerViewControllers indexOfObject:toViewController];
        if (fromIndex > toIndex) {
            toStart = -containerView.frame.size.width;
            fromEnd = containerView.frame.size.width;
        } else {
            toStart = containerView.frame.size.width;
            fromEnd = -containerView.frame.size.width;
        }
        toViewController.view.transform = CGAffineTransformMakeTranslation(toStart, 0);
    }
    [containerView insertSubview:toViewController.view
                    aboveSubview:fromViewController.view];
    toViewController.view.alpha = 0;
    [UIView animateWithDuration:self.transitionDuration
                          delay:0.0f
         usingSpringWithDamping:0.8f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         if (betweenMessengerViewControllers) {
                             toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                             fromViewController.view.transform = CGAffineTransformMakeTranslation(fromEnd, 0);
                         }
                         toViewController.view.alpha = 1;
                         fromViewController.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

@end
