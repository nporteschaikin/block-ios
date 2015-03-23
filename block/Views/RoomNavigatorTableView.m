//
//  RoomNavigatorTableView.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/22/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "RoomNavigatorTableView.h"
#import "UIColor+Block.h"

@implementation RoomNavigatorTableView

- (id)init {
    if (self = [super init]) {
        self.separatorColor = [UIColor clearColor];
        self.backgroundColor = [UIColor blockGreyColor];
    }
    return self;
}

@end
