//
//  DTDetailViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTDetailViewController.h"
#import "DTReviewTableViewController.h"
#import "DTModel.h"

@interface DTDetailViewController ()

@end

@implementation DTDetailViewController

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
  if(self.lot){
    [self initialize];
  }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialize
{
  self.lotOwner.text = [NSString stringWithFormat:@"%@", self.lot.user_id];
  self.distanceToVenue.text = [NSString stringWithFormat:@"%.1f mi", self.lot.distance.floatValue];
  self.averageReview.text = [NSString stringWithFormat:@"%.1f", self.lot.averageRating.floatValue];
  self.averagePrice.text = [NSString stringWithFormat:@"$%.2f", self.lot.averagePrice.floatValue];
}

- (IBAction)bookSpot:(id)sender {
  
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DTReviewTableViewController *reviewController = [segue destinationViewController];
  //reviewController.theUser = self.lot.user_id
#warning Needs to be implemented
  /*
  [[DTModel sharedInstance] getUserWithId:self.lot.user_id success:^(NSURLSessionDataTask *task, id responseObject) {
    reviewController.theUser = responseObject;
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
   
  }];
   */
}


@end
