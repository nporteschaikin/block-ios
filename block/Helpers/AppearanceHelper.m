//
//  AppearanceHelper.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "AppearanceHelper.h"
#import "UIFont+Block.h"

@implementation AppearanceHelper

+ (void)customizeAppearance {
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],
                                                            NSFontAttributeName:[UIFont defaultNavigationBarFont] }];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],
                                                         NSFontAttributeName:[UIFont defaultTabBarButtonFont] }
                                             forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],
                                                            NSFontAttributeName:[UIFont defaultBarButtonFont] }
                                                forState:UIControlStateNormal];
    [[UITextView appearance] setFont:[UIFont defaultTextViewFont]];
    [[UITextField appearance] setFont:[UIFont defaultTextFieldFont]];
    [[UILabel appearance] setFont:[UIFont defaultLabelFont]];
}

@end
