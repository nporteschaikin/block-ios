//
//  CreateRoomViewController.m
//  bloc
//
//  Created by Noah Portes Chaikin on 3/22/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "BlockTextField.h"
#import "UIColor+Block.h"
#import "APIManager+Cities.h"

@interface CreateRoomViewController ()

@property (strong, nonatomic) BlockTextField *nameTextField;
@property (strong, nonatomic) BlockTextField *descriptionTextField;
@property (strong, nonatomic) UIButton *saveButton;

@end

@implementation CreateRoomViewController

- (id)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor colorWithRed:0
                                                    green:0
                                                     blue:0
                                                    alpha:0.8];
        [self.view addSubview:self.nameTextField];
        [self.view addSubview:self.descriptionTextField];
        [self.view addSubview:self.saveButton];
        [self setupGestureRecognizer];
        [self setupConstraints];
    }
    return self;
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(dismissController)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)setupConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameTextField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:17]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameTextField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:17]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameTextField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-17]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionTextField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameTextField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionTextField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameTextField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionTextField
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameTextField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.descriptionTextField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:24]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameTextField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameTextField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
}

- (void)dismissController {
    [self.nameTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.theDelegate dismissCreateRoomViewController:self];
}

- (void)saveRoom {
    if (self.cityID
        && ![self.nameTextField.text isEqualToString:@""]
        && ![self.descriptionTextField.text isEqualToString:@""]) {
        self.saveButton.enabled = NO;
        [APIManager createRoomInCityWithID:self.cityID
                                      name:self.nameTextField.text
                               description:self.descriptionTextField.text
                                onComplete:^(NSDictionary *room) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.theDelegate createRoomViewController:self
                                                                       createdRoom:room];
                                        self.nameTextField.text = nil;
                                        self.descriptionTextField.text = nil;
                                        self.saveButton.enabled = YES;
                                    });
                                }];
    }
}

- (BlockTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[BlockTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.font = [UIFont fontWithName:@"Arial"
                                              size:15.f];
        _nameTextField.placeholder = @"Enter a name...";
    }
    return _nameTextField;
}

- (BlockTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[BlockTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        _descriptionTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionTextField.backgroundColor = [UIColor whiteColor];
        _descriptionTextField.font = [UIFont fontWithName:@"Arial"
                                                     size:15.f];
        _descriptionTextField.placeholder = @"Enter a description...";
    }
    return _descriptionTextField;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        _saveButton.frame = CGRectMake(0, 0, 0, 500);
        _saveButton.backgroundColor = [UIColor blockGreenColor];
        _saveButton.layer.cornerRadius = 3;
        _saveButton.titleLabel.font = [UIFont fontWithName:@"Arial"
                                                      size:15.f];
        [_saveButton setTitle:@"Save"
                     forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor blockGreyColor]
                          forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveRoom)
              forControlEvents:UIControlEventTouchDown];
    }
    return _saveButton;
}

@end
