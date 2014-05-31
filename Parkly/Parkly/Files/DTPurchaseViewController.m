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
  self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", self.theSpot.price.floatValue];
  self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.theLot.distance.floatValue];
  self.surfaceLabel.text = self.theSpot.surface;
  self.startDateLabel.text = self.theSpot.startDate;
  self.endDateLabel.text = self.theSpot.endDate;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
