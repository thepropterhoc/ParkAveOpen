//
//  DTMySpotTableViewCell.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 4/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTMySpotTableViewCell.h"
#import "DTModel.h"
#import <CoreLocation/CoreLocation.h>

@interface DTMySpotTableViewCell ()

@property (strong, nonatomic) NSString* theSpot;

@end

@implementation DTMySpotTableViewCell

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

-(void)initWithSpot:(NSString*)spot
{
  NSLog([NSString stringWithFormat:@"Parking spot init : %@", spot]);
  self.theSpot = spot;
  self.lotNameLabel.text = spot;

  //self.purchaseDateLabel.text = [spot.startDate stringByAppendingString:spot.endDate];
}

- (IBAction)navigate:(id)sender
{
  [[DTModel sharedInstance] getLotForSpot:self.theSpot success:^(NSURLSessionDataTask *task, DTParkingLot *responseObject) {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(responseObject.lat.floatValue, responseObject.lon.floatValue);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = responseObject.title;
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                              MKLaunchOptionsMapTypeKey : @0,
                              MKLaunchOptionsMapCenterKey : [NSValue valueWithMKCoordinate:coordinate],
                              MKLaunchOptionsMapSpanKey : [NSValue valueWithMKCoordinateSpan: MKCoordinateSpanMake(responseObject.distance.floatValue, responseObject.distance.floatValue)]
                              };
    
    [item openInMapsWithLaunchOptions:options];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Unable to open reserved spot.\nError : %@", error.description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
  }];
  
}

@end