//
//  DTTableCell.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotTableCell.h"
#import "DTModel.h"

@interface DTLotTableCell ()

@property (strong, nonatomic) NSArray *theSpots;

@end

@implementation DTLotTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithLot:(DTParkingLot*)lot
{
    self.ratingLabel.text = [NSString stringWithFormat:@"%.2f / 5", lot.averageRating.floatValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", [self distanceFromLot:lot]];
    self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", lot.minimumPrice.floatValue];
    self.titleLabel.text = lot.title;
}

-(float)distanceFromLot:(DTParkingLot*)lot
{
  return lot.distance.floatValue;
}

@end