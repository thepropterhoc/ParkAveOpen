//
//  DTLotFinderViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotFinderViewController.h"

@interface DTLotFinderViewController ()

@end

@implementation DTLotFinderViewController

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

- (IBAction)didSelectSegment:(UISegmentedControl *)sender {
  if(sender.selectedSegmentIndex == 0){
    //Sort elements of table by price
  } else if(sender.selectedSegmentIndex == 1){
    //Sort elements of table by distance
  } else if(sender.selectedSegmentIndex == 2){
    //Sort elements of table by surface type
  } else {
    //Sort elements of table by review rank
  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"embed"]){
    DTTableViewController *dest = [segue destinationViewController];
    dest.delegate = self;
  }
}

-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Received update about push of index at path : %d", indexPath.row);
}
@end
