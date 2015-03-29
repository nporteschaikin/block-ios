//
//  CreateRoomViewController.h
//  bloc
//
//  Created by Noah Portes Chaikin on 3/22/15.
//  Copyright (c) 2015 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateRoomViewController;

@protocol CreateRoomViewControllerDelegate

- (void)dismissCreateRoomViewController:(CreateRoomViewController *)createRoomViewController;

- (void)createRoomViewController:(CreateRoomViewController *)createRoomViewController
                     createdRoom:(NSDictionary *)room;

@end

@interface CreateRoomViewController : UIViewController

@property (strong, nonatomic) id<CreateRoomViewControllerDelegate> theDelegate;

- (id)initWithCityID:(NSString *)cityID
                city:(NSDictionary *)city;


@end
