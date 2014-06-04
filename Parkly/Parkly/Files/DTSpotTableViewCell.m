//
//  DTSpotTableViewCell.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTSpotTableViewCell.h"

@implementation DTSpotTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

-(void)initWithSpot:(DTParkingSpot *)spot
{
  self.startDateLabel.text = spot.shortStartDate;
  self.endDateLabel.text = spot.shortEndDate;
  self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", spot.price.floatValue];
  self.surfaceLabel.text = spot.surface;
  self.remainingLabel.text = [NSString stringWithFormat:@"%d remaining", spot.numSpots.intValue];
}

@end
