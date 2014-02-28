//
//  DTTableViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotTableViewController.h"
#import "DTLotTableCell.h"
#import "DTParkingLot.h"

@interface DTLotTableViewController ()

@property (strong, nonatomic) NSArray *theLots;

@end

@implementation DTLotTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  DTParkingLot *lot1 = [[DTParkingLot alloc] init];
  lot1.user_id = @"Moe's Garage";
  lot1.distance = @4.0;
  lot1.rating = @"3 / 5";
  
  DTParkingLot *lot2 = [[DTParkingLot alloc] init];
  lot2.user_id = @"A Mentlegen's Lot";
  lot2.distance = @2.0;
  lot2.rating = @"2 / 5";
  
  DTParkingLot *lot3 = [[DTParkingLot alloc] init];
  lot3.user_id = @"The Bat Cave";
  lot3.distance = @0.5;
  lot3.rating = @"4 / 5";
  
  self.theLots = @[lot1, lot2, lot3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.theLots count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Fetching cell for row : %d", indexPath.row);
  static NSString* identifier = @"cell";
  DTLotTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  [cell initWithLot:self.theLots[indexPath.row]]; 
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.delegate tableViewDidSelectRowAtIndexPath:indexPath];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)sortByPrice
{
  
}

-(void)sortByDistance
{
  
}

-(void)sortByType
{
  
}

-(void)sortByReview
{
  
}

@end
