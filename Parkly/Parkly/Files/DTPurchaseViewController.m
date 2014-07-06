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

- (IBAction)tryToReserve:(id)sender
{
  if(![[DTModel sharedInstance] userIsLoggedIn]){
    [[[UIAlertView alloc] initWithTitle:@"Ack!" message:@"Please log in first" delegate:nil cancelButtonTitle:@"Ok, fine" otherButtonTitles: nil] show];
  } else {
    [[DTModel sharedInstance] purchaseSpot:self.theSpot forUser:[[DTModel sharedInstance] currentUser] withCar:[[DTModel sharedInstance] defaultCar] success:^(NSURLSessionDataTask *task, id responseObject) {
      [self.navigationController popViewControllerAnimated:YES];
      [[[UIAlertView alloc] initWithTitle:@"Break out the champagne!" message:@"Successfully purchased this spot.  Find it in your cart." delegate:nil cancelButtonTitle:@"Let's do this" otherButtonTitles: nil] show];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      [[[UIAlertView alloc] initWithTitle:@"Aw, crap" message:@"Couldn't buy this spot for you.  Sorry about that." delegate:nil cancelButtonTitle:@"We'll let it go this time" otherButtonTitles: nil] show];
    }];
  }
}

@end
