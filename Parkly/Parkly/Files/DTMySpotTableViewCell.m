//
//  DTMySpotTableViewCell.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 6/4/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTMySpotTableViewCell.h"

@implementation DTMySpotTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initWithSpot:(DTParkingSpot *)spot lot:(DTParkingLot *)lot
{
  self.lotTitleLabel.text = lot.title;
  if(lot.distance && lot.distance.intValue != -1){
    float feet = lot.distance.floatValue * 3.28084;
    if (feet > 5280){
      [self.lotDistanceLabel setText:[NSString stringWithFormat:@"%.2f mi", (feet / 5280.0f)]];
    } else {
      [self.lotDistanceLabel setText:[NSString stringWithFormat:@"%.f ft", feet]];
    }
  } else {
    [self.lotDistanceLabel setText:@"N/A"];
  }
  self.startDateLabel.text = spot.shortStartDate;
  self.endDateLabel.text = spot.shortEndDate;
  [[DTModel sharedInstance] imageForLot:lot success:^(NSURLSessionDataTask *task, id responseObject) {
    self.lotImageView.image = responseObject;
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    self.lotImageView.image = nil;
  }];
}

@end
