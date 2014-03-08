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
#import "DTModel.h"

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
  
  
  //Frankly, this should be in Interface Builder, but for some reason they haven't included Refresh Controls in the object list yet.  Weird...
  UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
  [refresher addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
  [self.theTable addSubview:refresher];
  
  [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View implementation methods

/*
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 93.0f;
}
*/
 
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



#pragma mark - Table Sorting methods

-(void)sortByPrice
{
  self.theLots = [self.theLots sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [((DTParkingLot*) obj1).averagePrice compare:((DTParkingLot *) obj2).averagePrice];
  }];
  [self.theTable reloadData];
}

-(void)sortByDistance
{
  /*
  [[DTModel sharedInstance] sortLots:[NSMutableArray arrayWithArray:self.theLots] byDistanceFromLatitude:1.0f andLongitude:1.0f isDescending:YES];
  */
  
  self.theLots = [self.theLots sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [((DTParkingLot*) obj1).distance compare:((DTParkingLot *) obj2).distance];
  }];
  [self.theTable reloadData];
}

-(void)sortByReview
{
  /*
  self.theLots = [[DTModel sharedInstance] sortLotsByRating:self.theLots isAscending:YES];
  */
  
  self.theLots = [self.theLots sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [((DTParkingLot*) obj1).averageRating compare:((DTParkingLot *) obj2).averageRating];
  }];
  [self.theTable reloadData];
}

-(void)sortByName
{
  self.theLots = [self.theLots sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [((DTParkingLot*) obj1).title compare:((DTParkingLot *) obj2).title];
  }];
  [self.theTable reloadData];
}



#pragma mark - Connection fetching methods

-(void)refreshData:(UIRefreshControl*)refresher
{
  [refresher endRefreshing];
  [self fetchData];
}

-(void)fetchData
{
  [[DTModel sharedInstance] getAllLots:^(NSURLSessionDataTask *task, NSArray *allLots) {
    self.theLots = allLots;
    [self.theTable reloadData];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to fetch lots.  Check the network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
  }];
}

@end
