//
//  DTSpotTableViewCell.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTParkingSpot.h"
#import "DTParkingLot.h"
#import <UIKit/UIKit.h>

@protocol DTSpotTableViewCellDelegate <NSObject>

-(void)didSelectSpot:(DTParkingSpot*)spot withLot:(DTParkingLot*)lot;

@end

@interface DTSpotTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *surfaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainingLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) id<DTSpotTableViewCellDelegate> delgate;

-(void)initWithSpot:(DTParkingSpot*)spot;

@end
