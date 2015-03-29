//
//  AppearanceHelper.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "AppearanceHelper.h"
#import "UIColor+Block.h"
#import "UIFont+Block.h"

@implementation AppearanceHelper

+ (void)customizeAppearance {
    [[UITextView appearance] setFont:[UIFont defaultTextViewFont]];
    [[UITextField appearance] setFont:[UIFont defaultTextFieldFont]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blockGreyColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blockGreenColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blockGreenColor]}];
    [[UISearchBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UISearchBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UISearchBar appearance] setBackgroundImage:[[UIImage alloc] init]];
}

@end
