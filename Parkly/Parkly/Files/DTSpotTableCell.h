//
//  DTSpotTableCell.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTParkingSpot.h"

@interface DTSpotTableCell : UITableViewCell

-(void)initWithParkingSpot:(DTParkingSpot*)spot;

@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *spotType;
@property (strong, nonatomic) IBOutlet UILabel *spotDate;


@end
