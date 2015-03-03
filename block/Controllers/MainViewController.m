//
//  MainViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/4/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController()

@property (weak, nonatomic) UIViewController *currentViewController;

@end

@implementation MainViewController

- (id)initWithCurrentViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.currentViewController = viewController;
        [self addChildViewController:viewController];
        [self.view addSubview:self.currentViewController.view];
        [self.currentViewController didMoveToParentViewController:self];
    }
    return self;
}

- (void)transitionToViewController:(UIViewController *)toViewController
                          duration:(NSTimeInterval)duration
                           options:(UIViewAnimationOptions)options
                        animations:(void (^)(UIViewController *lastController))animations
                        completion:(void (^)(BOOL))completion {
    [self addChildViewController:toViewController];
    __weak __block MainViewController *weakSelf = self;
    [self transitionFromViewController:self.currentViewController
                      toViewController:toViewController
                              duration:duration
                               options:options
                            animations:^{
                                if (animations) animations(weakSelf.currentViewController);
                            }
                            completion:^(BOOL finished) {
                                [weakSelf.currentViewController willMoveToParentViewController:nil];
                                [weakSelf.currentViewController removeFromParentViewController];
                                weakSelf.currentViewController = toViewController;
                                if (completion) completion(finished);
                             }];
}

- (void)slideToViewController:(UIViewController *)toViewController
                     duration:(NSTimeInterval)duration
                   completion:(void (^)(BOOL))completion {
    [self transitionToViewController:toViewController
                            duration:duration
                             options:UIViewAnimationOptionTransitionNone
                          animations:^(UIViewController *lastController) {
                              CGFloat width = CGRectGetWidth(lastController.view.frame);
                              CGFloat height = CGRectGetHeight(lastController.view.frame);
                              lastController.view.frame = CGRectMake(0 - width, 0, width, height);
                              toViewController.view.frame = CGRectMake(0, 0, width, height);
                          } completion:completion];
}

- (void)fadeToViewController:(UIViewController *)toViewController
                    duration:(NSTimeInterval)duration
                  completion:(void (^)(BOOL))completion {
    [self transitionToViewController:toViewController
                            duration:duration
                             options:UIViewAnimationOptionTransitionNone
                          animations:^(UIViewController *lastController) {
                              lastController.view.alpha = 0.0;
                          } completion:completion];
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers{
    return YES;
}

@end
