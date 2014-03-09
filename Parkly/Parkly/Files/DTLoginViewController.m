//
//  DTLoginViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLoginViewController.h"
#import "DTModel.h"
#import "DTUser.h"

@interface DTLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation DTLoginViewController

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

-(void)viewDidAppear:(BOOL)animated
{
  [self.emailField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(id)sender
{
  [self.emailField resignFirstResponder];
  [self.passwordField resignFirstResponder];
}

- (IBAction)login:(id)sender
{
  [[DTModel sharedInstance] authenticateUserWithEmail:self.emailField.text andPassword:self.passwordField.text success:^(NSURLSessionDataTask *task, DTUser *user) {
    [[[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"Successfully logged in %@ %@", user.firstName, user.lastName] delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
    [self.delegate dismissLoginViewController];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid login information" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
  }];
}

- (IBAction)cancel:(id)sender
{
  [self.delegate dismissLoginViewController];
}

@end
