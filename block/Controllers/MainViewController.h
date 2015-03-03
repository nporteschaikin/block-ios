//
//  MainViewController.h
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

- (id)initWithCurrentViewController:(UIViewController *)viewController;
- (void)transitionToViewController:(UIViewController *)toViewController
                          duration:(NSTimeInterval)duration
                           options:(UIViewAnimationOptions)options
                        animations:(void (^)(UIViewController *lastController))animations
                        completion:(void (^)(BOOL))completion;
- (void)slideToViewController:(UIViewController *)toViewController
                     duration:(NSTimeInterval)duration
                   completion:(void (^)(BOOL))completion;
- (void)fadeToViewController:(UIViewController *)toViewController
                    duration:(NSTimeInterval)duration
                  completion:(void (^)(BOOL))completion;
@end
