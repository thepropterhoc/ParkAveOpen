//
//  DTBuyViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 3/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTBuyViewController.h"
#import "DTReceiptViewController.h"
#import "DTModel.h"

@interface DTBuyViewController ()

@property (strong, nonatomic) DTLoginViewController *loginViewController;
@property (strong, nonatomic) DTSignupViewController *signupViewController;

@end

@implementation DTBuyViewController

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
  [self populateFields];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateFields
{
  self.lotNameLabel.text = self.theLot.title;
  self.lotOwnerLabel.text = self.theLot.user_id;
  self.lotDistanceLabel.text = [NSString stringWithFormat:@"%.1f", self.theLot.distance.floatValue];
  self.lotRatingLabel.text = [NSString stringWithFormat:@"%d / 5", self.theLot.averageRating.intValue];
  self.spotTypeLabel.text = self.theSpot.surface;
  self.spotDateLabel.text = self.theSpot.startDate;
  self.spotPriceLabel.text = [NSString stringWithFormat:@"%.2f", self.theSpot.price.floatValue];
}

- (IBAction)tryToReserve:(id)sender
{
  if([[DTModel sharedInstance] userHasAccount]){
    if([[DTModel sharedInstance] userIsLoggedIn]){
      [self performSegueWithIdentifier:@"goToReceipt" sender:self];
    } else {
      [self pushToLoginViewController];
    }
  } else {
    [self pushToSignupViewController];
  }
}

-(void)pushToLoginViewController
{
  [self performSegueWithIdentifier:@"pushToLogin" sender:self];
}

-(void)pushToSignupViewController
{
  [self performSegueWithIdentifier:@"pushToSignup" sender:self];
}

-(NSString*)generateReceipt
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  NSString *currentDate = [formatter stringFromDate:[NSDate date]];
  return [NSString stringWithFormat:@"Purchaser : %@\nSeller : %@\nDate of Purchase : %@\nAmount of Purchase : %@\nDate of Reservation : %@\nLot Name : %@\nLot Location : %@\nSpot Surface Type : %@", [DTModel sharedInstance].currentUser._id, self.theLot.user_id, currentDate, [NSString stringWithFormat:@"%.2f", self.theSpot.price.floatValue], self.theSpot.startDate, self.theLot.title, [NSString stringWithFormat:@"%.4f, %.4f", self.theLot.lat.floatValue, self.theLot.lon.floatValue], self.theSpot.surface];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"goToReceipt"]){
    DTReceiptViewController *dest = [segue destinationViewController];
    dest.theReceipt = [self generateReceipt];
  } else if([[segue identifier] isEqualToString:@"pushToLogin"]) {
    self.loginViewController = [segue destinationViewController];
    self.loginViewController.delegate = self;
  } else if([[segue identifier] isEqualToString:@"pushToSignup"]){
    self.signupViewController = [segue destinationViewController];
    self.signupViewController.delegate = self;
  }
}

-(void)dismissLoginViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissSignupViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
