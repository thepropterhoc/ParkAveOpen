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
  if(lot.averagePrice && lot.averageRating && lot.distance){
    self.ratingLabel.text = [NSString stringWithFormat:@"%.2f", lot.averageRating.floatValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", lot.distance.floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", lot.averagePrice.floatValue];
  } else {
    self.ratingLabel.text = @"None";
    self.distanceLabel.text = @"None";
    self.priceLabel.text = @"None";
  }
  self.titleLabel.text = lot.title;
}

-(float)averagePriceForLot:(DTParkingLot*)lot
{
  NSArray *theSpots = nil;
  [[DTModel sharedInstance] getSpotsForLot:lot success:^(NSURLSessionDataTask *task, NSArray *spots) {
    self.theSpots = spots;
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    self.theSpots = nil;
  }];
  
  if(theSpots){
    float average = 0.0f;
    for(DTParkingSpot *spot in self.theSpots){
      average = spot.price.floatValue;
    }
    return average/([self.theSpots count]);
  } else {
    return -1.0f;
  }
}

@end
