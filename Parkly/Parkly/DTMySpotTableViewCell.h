//
//  DTMySpotTableViewCell.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 4/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTParkingSpot.h"

@interface DTMySpotTableViewCell : UITableViewCell

-(void)initWithSpot: (DTParkingSpot*)spot;
@property (strong, nonatomic) IBOutlet UILabel *lotNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *purchaseDateLabel;

@end
