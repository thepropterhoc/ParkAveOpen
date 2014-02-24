//
//  DTTableViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotTableViewController.h"
#import "DTTableCell.h"

@interface DTLotTableViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Fetching cell for row : %d", indexPath.row);
  static NSString* identifier = @"cell";
  DTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  if(!cell){
    cell = [[DTTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  if(indexPath.row == 0){
    cell.titleLabel.text = @"Moe's Garage";
    cell.priceLabel.text = @"$20.00";
    cell.distanceLabel.text = @"1.0 mi";
    cell.surfaceTypeLabel.text = @"Gravel";
    cell.ratingLabel.text = @"3 / 5";
  } else if(indexPath.row == 1){
    cell.titleLabel.text = @"A Mentlegen's Lot";
    cell.priceLabel.text = @"$15.00";
    cell.distanceLabel.text = @"2.0 mi";
    cell.surfaceTypeLabel.text = @"Dirt";
    cell.ratingLabel.text = @"2 / 5";
  } else {
    cell.titleLabel.text = @"The Bat Cave";
    cell.priceLabel.text = @"$10.00";
    cell.distanceLabel.text = @"0.5 mi";
    cell.surfaceTypeLabel.text = @"Asphalt";
    cell.ratingLabel.text = @"4 / 5";
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.delegate tableViewDidSelectRowAtIndexPath:indexPath];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
