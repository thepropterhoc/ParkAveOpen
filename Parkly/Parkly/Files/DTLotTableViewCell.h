//
//  DTLotTableViewCell.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/20/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTParkingLot.h"

@interface DTLotTableViewCell : UITableViewCell

-(void)initWithLot:(DTParkingLot*)lot;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *theImage;
@property (strong, nonatomic) IBOutlet UILabel *averagePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageReviewLabel;

@end
