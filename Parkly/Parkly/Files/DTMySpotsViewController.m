//
//  DTMySpotsViewController.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 6/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTMySpotsViewController.h"
#import "DTMySpotTableViewCell.h"

@interface DTMySpotsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) NSArray *mySpots;

@end

@implementation DTMySpotsViewController

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
  for (NSString *lotID in self.mySpots){
    
  }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.mySpots.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DTMySpotTableViewCell *cell = (DTMySpotTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  if(!cell){
    cell = [[DTMySpotTableViewCell alloc] init];
  }
  [[DTModel sharedInstance] getLotForSpot:self.mySpots[indexPath.row] success:^(NSURLSessionDataTask *task, DTParkingLot *responseObject) {
    [cell initWithSpot:self.mySpots[indexPath.row] lot:responseObject];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"Unable to fetch lot for spot.  Error : %@", error.description);
  }];
  return cell;
}

- (IBAction)dismiss:(id)sender
{
  [self.delegate dismissMySpotsViewController];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self openNavigationToSpot:self.mySpots[indexPath.row]];
}

-(void)openNavigationToSpot:(DTParkingSpot*)spot
{
  NSLog(@"Navigate to spot");
}

@end
