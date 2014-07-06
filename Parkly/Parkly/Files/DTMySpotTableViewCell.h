//
//  DTMySpotTableViewCell.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 6/4/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTParkingSpot.h"
#import "DTParkingLot.h"
#import "DTModel.h"
#import <UIKit/UIKit.h>

@interface DTMySpotTableViewCell : UITableViewCell

-(void)initWithSpot:(DTParkingSpot*)spot lot:(DTParkingLot*)lot;
@property (strong, nonatomic) IBOutlet UILabel *lotTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lotDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lotImageView;

@end
