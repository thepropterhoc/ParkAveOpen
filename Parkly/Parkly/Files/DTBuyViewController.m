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

-(void)buyTheSpot
{
  [self performSegueWithIdentifier:@"goToReceipt" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"goToReceipt"]){
    DTReceiptViewController *receiptViewController = [segue destinationViewController];
    receiptViewController.receipt = [self generateReceipt];
  }
}

-(NSString*)generateReceipt
{
  NSString *output = @"";
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  NSString *datePurchased = [formatter stringFromDate:[NSDate date]];
  output = [output stringByAppendingString:[NSString stringWithFormat:@"Purchaser : %@\nSeller : %@\nDate of Purchase : %@\nDate of Arrival : %@\nAmount of purchase : %@\nDestination lot : %@\nLot coordinates : %@, %@\nSpot Type : %@", [[[DTModel sharedInstance]currentUser].firstName stringByAppendingString:[[DTModel sharedInstance] currentUser].lastName], self.theLot.user_id, datePurchased, self.theSpot.endDate, [NSString stringWithFormat:@"%.2f", self.theSpot.price.floatValue], self.theLot.title, self.theLot.lat, self.theLot.lon, self.theSpot.surface]];
  return output;
}

- (IBAction)reserve:(id)sender
{
  [self buyTheSpot];
}
@end
