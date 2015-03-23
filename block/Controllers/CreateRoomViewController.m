//
//  CreateRoomViewController.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/22/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "CreateRoomViewController.h"

@implementation CreateRoomViewController

- (id)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(dismiss)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil];
        self.navigationItem.title = @"Create a Room";
    }
    return self;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
