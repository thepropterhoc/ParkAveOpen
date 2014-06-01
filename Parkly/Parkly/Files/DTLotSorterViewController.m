//
//  DTLotSorterViewController.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/20/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotSorterViewController.h"
#import "DTLotTableViewCell.h"
#import "DTLotExpandedTableViewCell.h"
#import "DTSpotTableViewCell.h"
#import "DTPurchaseViewController.h"
#import "DTModel.h"

@interface DTLotSorterViewController ()

@property (strong, nonatomic) NSArray *lots;
@property (strong ,nonatomic) NSNumber *selectedRow;
@property (strong, nonatomic) DTParkingLot *pushLot;
@property (strong, nonatomic) DTParkingSpot *pushSpot;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation DTLotSorterViewController

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
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
  [self loadLots];
  [self.mapButton.layer setCornerRadius:10.0f];
  self.selectedRow = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(tableView.tag == 0){
    if(self.selectedRow && self.selectedRow.intValue == indexPath.row){
      DTLotExpandedTableViewCell *cell = (DTLotExpandedTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Expanded" forIndexPath:indexPath];
      if(!cell){
        cell = [[DTLotExpandedTableViewCell alloc] init];
      }
      [cell initWithLot:self.lots[indexPath.row]];
      cell.passthrough = self;
      return cell;
    } else {
      DTLotTableViewCell *cell = (DTLotTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
      if(!cell){
        cell = [[DTLotTableViewCell alloc] init];
      }
      [cell initWithLot:self.lots[indexPath.row]];
      return cell;
    }
  } else {
    DTSpotTableViewCell *cell = (DTSpotTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell){
      cell = [[DTSpotTableViewCell alloc] init];
    }
    //Init the cell
    return cell;
  }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.lots.count;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([[[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"Expanded"]){
    self.selectedRow = nil;
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
    return nil;
  } else {
    if(self.selectedRow){
      int old = self.selectedRow.intValue;
      self.selectedRow = nil;
      [tableView reloadRowsAtIndexPaths:
       @[[NSIndexPath indexPathForRow:old inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    self.selectedRow = [NSNumber numberWithInt: indexPath.row];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
    return nil;
  }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(self.selectedRow && indexPath.row == self.selectedRow.intValue){
    return 300.0f;
  } else {
    return 100.0f;
  }
}

-(void)didSelectSpot:(DTParkingSpot *)spot withLot:(DTParkingLot *)lot
{
  self.pushSpot = spot;
  self.pushLot = lot;
  [self performSegueWithIdentifier:@"pushToPurchase" sender:self];
}

-(void)refresh
{
  [[DTModel sharedInstance] removeCachedLots];
  [self loadLots];
}

-(void) loadLots
{
  [[DTModel sharedInstance] getAllLots:^(NSURLSessionDataTask *task, NSArray *allLots) {
    self.lots = allLots;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"Critical error fetching lots");
    [self.refreshControl endRefreshing];
  }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"pushToPurchase"]){
    DTPurchaseViewController *dest = [segue destinationViewController];
    dest.theLot = self.pushLot;
    dest.theSpot = self.pushSpot;
  }
}
 
@end
