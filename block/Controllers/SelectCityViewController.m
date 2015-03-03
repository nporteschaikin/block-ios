//
//  SelectCityViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController ()

@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) SessionManager *sessionManager;

@end

@implementation SelectCityViewController

- (id)initWithCities:(NSArray *)cities
      sessionManager:(SessionManager *)sessionManager {
    if (self = [super init]) {
        self.cities = [NSMutableArray arrayWithArray:cities];
        self.sessionManager = sessionManager;
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
