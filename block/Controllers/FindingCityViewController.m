//
//  FindingCityViewController.m
//  block
//
//  Created by Noah Portes Chaikin on 3/3/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "FindingCityViewController.h"
#import "APIManager+Cities.h"
#import "UIColor+Block.h"

static NSString * const locatingStatusLabelText = @"Locating a city closest to you...";
static NSString * const noCitiesAroundLocationStatusLabelText = @"There are no cities around your current location.";
static NSString * const couldNotFindLocationStatusLabelText = @"Block could not find your location.";

@interface FindingCityViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) SessionManager *sessionManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation FindingCityViewController

- (id)initWithSessionManager:(SessionManager *)sessionManager {
    if (self = [super init]) {
        self.sessionManager = sessionManager;
        self.view.backgroundColor = [UIColor blockGreyColor];
        [self.view addSubview:self.statusLabel];
        [self setupConstraints];
    }
    return self;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _statusLabel.numberOfLines = 0;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = locatingStatusLabelText;
        _statusLabel.textColor = [UIColor blockGreenColor];
    }
    return _statusLabel;
}

- (void)setupConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-20]];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation {
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.statusLabel.text = locatingStatusLabelText;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations firstObject];
    [self updateCitiesByLocation:location];
    [manager stopUpdatingLocation];
}

- (void)updateCitiesByLocation:(CLLocation *)location {
    [APIManager getCitiesByLocation:location
                          onSuccess:^(NSArray *cities) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  switch (cities.count) {
                                      case 1:
                                          [self.delegate findingCityViewController:self
                                                                 didFindSingleCity:[cities firstObject]];
                                          break;
                                      case 0:
                                          self.statusLabel.text = noCitiesAroundLocationStatusLabelText;
                                          break;
                                      default:
                                          [self.delegate findingCityViewController:self
                                                             didFindMultipleCities:cities];
                                          break;
                                  }
                              });
                          } onFail:^(NSURLResponse *response, NSData *data) {
                              // this should never happen.
                          } onError:^(NSError *error) {
                              // this may happen (no internet connection)
                          }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.statusLabel.text = couldNotFindLocationStatusLabelText;
}

@end
