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
    self.ratingLabel.text = [NSString stringWithFormat:@"%.2f", lot.averageRating.floatValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", [self distanceFromLot:lot]];
    self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", lot.minimumPrice.floatValue];
    self.titleLabel.text = lot.title;
}

# warning temporarily hard-coded to the NWC coordinates for demonstration PR2. Add location manager.
-(float)distanceFromLot:(DTParkingLot*)lot
{
    NSInteger R = 6371; // km
    float NWCLatDegrees = 35.18158;
    float NWCLonDegrees = -97.43986;
    
    float NWCLatRadians = NWCLatDegrees * 2.0 * M_PI / 360.0;
    float NWCLonRadians = NWCLonDegrees * 2.0 * M_PI / 360.0;
    
    float currentLatRadians = [lot.lat floatValue] * 2.0 * M_PI / 360.0;
    float currentLonRadians = [lot.lon floatValue] * 2.0 * M_PI / 360.0;
    
    float dLat = NWCLatRadians - currentLatRadians;
    float dLon = NWCLonRadians - currentLonRadians;
    
    float a = sinf(dLat/2) * sinf(dLat/2) + sinf(dLon/2) * sinf(dLon/2) * cosf(currentLatRadians * cosf(NWCLatRadians));
    float c = 2 * atan2(sqrt(a), sqrt(1-a));
    float d = R * c;
    
    return d;
}

@end