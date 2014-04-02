//
//  DTLotFinderViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotFinderViewController.h"
#import "DTDetailViewController.h"
#import "DTModel.h"

@interface DTLotFinderViewController ()

@property (weak, nonatomic) DTLotTableViewController *lotTable;
@property (weak, nonatomic) DTProfileViewController *profileViewController;
@property (weak, nonatomic) DTLoginViewController *loginViewController;
@property (weak, nonatomic) DTSignupViewController *signupViewController;

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
  [self.view layoutSubviews];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSelectSegment:(UISegmentedControl *)sender {
  
  if(sender.selectedSegmentIndex == 0){
    [self.lotTable sortByDistance];
  }else if(sender.selectedSegmentIndex == 1){
    [self.lotTable sortByReview];
  } else if(sender.selectedSegmentIndex == 2){
    [self.lotTable sortByPrice];
  } else if(sender.selectedSegmentIndex == 3){
    [self.lotTable sortByName];
  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"embed"]){
    self.lotTable = [segue destinationViewController];
    self.lotTable.delegate = self;
  } else if([[segue identifier] isEqualToString:@"pushToView"]){
    self.profileViewController = [segue destinationViewController];
    self.profileViewController.delegate = self;
    self.profileViewController.theUser = [[DTModel sharedInstance] currentUser];
  } else if([[segue identifier] isEqualToString:@"pushToDetail"]){
    ((DTDetailViewController*) [segue destinationViewController]).lot = self.lotTable.theLots[self.lotTable.theTable.indexPathForSelectedRow.row];
  } else if([[segue identifier] isEqualToString:@"pushToLogin"]){
    self.loginViewController = [segue destinationViewController];
    self.loginViewController.delegate = self;
  } else if([[segue identifier] isEqualToString:@"pushToSignup"]){
    self.signupViewController = [segue destinationViewController];
    self.signupViewController.delegate = self;
  }
}

-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"pushToDetail" sender:self];
}

-(void)dismissProfileViewControllerSuccess
{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

-(void)dismissProfileViewControllerCanceled
{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

-(void)dismissLoginViewController
{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

-(void)dismissSignupViewController
{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (IBAction)viewProfile:(id)sender
{
  if([[DTModel sharedInstance] userHasAccount] && [[DTModel sharedInstance] userIsLoggedIn]){
    [self performSegueWithIdentifier:@"pushToView" sender:self];
  } else if([[DTModel sharedInstance] userHasAccount] && ![[DTModel sharedInstance] userIsLoggedIn]){
    [self performSegueWithIdentifier:@"pushToLogin" sender:self];
  } else {
    [self performSegueWithIdentifier:@"pushToSignup" sender:self];
  }
}

@end
