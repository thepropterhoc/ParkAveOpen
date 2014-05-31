//
//  DTLotExpandedTableViewCell.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/20/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotExpandedTableViewCell.h"
#import "DTSpotTableViewCell.h"
#import "DTModel.h"
#import <QuartzCore/QuartzCore.h>

@interface DTLotExpandedTableViewCell ()

@property (strong, nonatomic) NSArray *theSpots;
@property (strong, nonatomic) DTParkingLot *theLot;

@end

@implementation DTLotExpandedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
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
  self.theLot = lot;
  [self.theTable setDelegate:self];
  [self.theTable setDataSource:self];
  self.lotNameLabel.text = lot.title;
  self.distanceLabel.text = [NSString stringWithFormat:@"%@ mi", lot.distance];
  
  [[DTModel sharedInstance] imageForLot:lot success:^(NSURLSessionDataTask *task, id responseObject) {
    [self.theImage setImage:responseObject forState:UIControlStateNormal];
    [self.theImage.layer setCornerRadius:self.theImage.frame.size.height/2];
    [self.theImage.layer setBorderWidth:2.0f];
    [self.theImage.layer setBorderColor:[[UIColor colorWithRed:1.0f green:0.0f blue:0.5f alpha:1.0f] CGColor]];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [self.theImage setImage:nil forState:UIControlStateNormal];
  }];
  
  DTParkingSpot* one = [[DTParkingSpot alloc] init];
  one.surface = @"Gravel";
  one.price = @15.0;
  one.startDate = @"06/24/2014";
  one.endDate = @"06/25/2014";
  one.numSpots = @3;
  
  DTParkingSpot *two = [[DTParkingSpot alloc] init];
  two.surface = @"Dirt";
  two.price = @20.0;
  two.startDate = @"07/04/2014";
  two.endDate = @"07/05/2014";
  two.numSpots = @4;
  
  self.theSpots = @[one, two];
  [self.theTable reloadData];
  /*
  [[DTModel sharedInstance] getSpotsForLot:lot success:^(NSURLSessionDataTask *task, NSArray *spots) {
    self.theSpots = spots;
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"Failure to get spots for lot: %@", lot.title);
    self.theSpots = nil;
  }];
   */
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.theSpots.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DTSpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  if(!cell){
    cell = [[DTSpotTableViewCell alloc] init];
  }
  [cell initWithSpot:self.theSpots[indexPath.row]];
  cell.delgate = self.passthrough;
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.passthrough didSelectSpot:self.theSpots[indexPath.row] withLot:self.theLot];
}

@end
