//
//  DTPurchaseViewController.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/27/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTPurchaseViewController.h"

@interface DTPurchaseViewController ()

@end

@implementation DTPurchaseViewController

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
  self.priceLabel.text = [NSString stringWithFormat:@"$ %.2f", self.theSpot.price.floatValue];
  
  float feet = self.theLot.distance.floatValue * 3.28084;
  if (feet > 5280){
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.2f mi", (feet / 5280.0f)]];
  } else {
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.f ft", feet]];
  }
  self.surfaceLabel.text = self.theSpot.surface;
  self.startDateLabel.text = self.theSpot.shortStartDate;
  self.endDateLabel.text = self.theSpot.shortEndDate;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushToProfile:(id)sender
{
  [self performSegueWithIdentifier:@"pushToProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"pushToProfile"]){
    ((DTProfileViewController*) [segue destinationViewController]).delegate = self;
  }
}

-(void)dismissProfileViewController:(id)profile
{
  [self dismissViewControllerAnimated:YES
                           completion:^{
                             
                           }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
