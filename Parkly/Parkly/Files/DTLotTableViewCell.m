//
//  DTLotTableViewCell.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/20/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotTableViewCell.h"
#import "DTModel.h"

#import <QuartzCore/QuartzCore.h>

@implementation DTLotTableViewCell

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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithLot:(DTParkingLot *)lot
{
  [self.titleLabel setText:lot.title];
  if(lot.minimumPrice && lot.minimumPrice.intValue != -1){
    [self.averagePriceLabel setText:[NSString stringWithFormat:@"$%@", lot.minimumPrice]];
  } else {
    [self.averagePriceLabel setText:@"N/A"];
  }
  if(lot.averageRating && lot.averageRating.intValue != -1){
    [self.averageReviewLabel setText:[NSString stringWithFormat:@"%@/5", lot.averageRating]];
  } else {
    [self.averageReviewLabel setText:@"N/A"];
  }
  if(lot.distance && lot.distance.intValue != -1){
    [self.distanceLabel setText:[NSString stringWithFormat:@"%@ mi", lot.distance]];
  } else {
    [self.distanceLabel setText:@"N/A"];
  }
  
  [[DTModel sharedInstance] imageForLot:lot success:^(NSURLSessionDataTask *task, id responseObject) {
    [self.theImage setImage:responseObject];
    [self.theImage.layer setCornerRadius:self.theImage.frame.size.height/2];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"Error fetching image for lot : %@", lot.title);
  }];
}

@end
