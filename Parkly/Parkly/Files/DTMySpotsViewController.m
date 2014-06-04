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
  [cell initWithSpot:self.mySpots[indexPath.row]];
  return cell;
}

- (IBAction)dismiss:(id)sender
{
  [self.delegate dismissMySpotsViewController];
}

@end
