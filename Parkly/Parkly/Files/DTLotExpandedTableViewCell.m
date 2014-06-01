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
  
  float feet = lot.distance.floatValue * 3.28084;
  if (feet > 5280){
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.2f mi", (feet / 5280.0f)]];
  } else {
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.f ft", feet]];
  }
  
  [[DTModel sharedInstance] imageForLot:lot success:^(NSURLSessionDataTask *task, id responseObject) {
    [self.theImage setImage:responseObject forState:UIControlStateNormal];
    [self.theImage.layer setCornerRadius:self.theImage.frame.size.height/2];
    [self.theImage.layer setBorderWidth:2.0f];
    [self.theImage.layer setBorderColor:[[UIColor colorWithRed:1.0f green:0.0f blue:0.5f alpha:1.0f] CGColor]];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [self.theImage setImage:nil forState:UIControlStateNormal];
  }];
  //[self.refreshControl beginRefreshing];
  [self loadSpots];
  
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

-(void) loadSpots
{
  [[DTModel sharedInstance] getSpotsForLot:self.theLot success:^(NSURLSessionDataTask *task, NSArray *spots) {
    self.theSpots = spots;
    [self.theTable reloadData];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"Failure to get spots for lot: %@", self.theLot.title);
    self.theSpots = nil;
  }];
  [self.theTable reloadData];
}

@end
