//
//  DTPurchaseViewController.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/27/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//


#import "DTParkingLot.h"
#import "DTParkingSpot.h"
#import "DTModel.h"
#import "DTProfileViewController.h"
#import <UIKit/UIKit.h>

@interface DTPurchaseViewController : UIViewController <DTProfileViewControllerDelegate>

@property (strong, nonatomic) DTParkingLot *theLot;
@property (strong, nonatomic) DTParkingSpot *theSpot;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *surfaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;

@end
