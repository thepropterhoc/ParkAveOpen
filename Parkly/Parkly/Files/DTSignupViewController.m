//
//  DTSignupViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 3/9/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTSignupViewController.h"
#import "DTUser.h"
#import "DTModel.h"

@interface DTSignupViewController ()

@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *monthField;
@property (strong, nonatomic) IBOutlet UITextField *dayField;
@property (strong, nonatomic) IBOutlet UITextField *yearField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;

@end

@implementation DTSignupViewController

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

-(DTUser*)userFromFields
{
  DTUser *theUser = [[DTUser alloc] init];
  theUser.firstName = self.firstNameField.text;
  theUser.lastName = self.lastNameField.text;
  theUser.email = self.emailField.text;
  theUser.password = self.passwordField.text;
  theUser.birthdate = [NSString stringWithFormat:@"%d/%d/%d", self.monthField.text.intValue, self.dayField.text.intValue, self.yearField.text.intValue];
  theUser.phone = self.phoneField.text;
  return theUser;
}

- (IBAction)signup:(id)sender
{
  [[DTModel sharedInstance] createUser:[self userFromFields] success:^(NSURLSessionDataTask *task, DTUser *newUser) {
    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully created an account.  Welcome to Park Ave." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show
     ];
    [self.delegate dismissSignupViewController];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error creating an account.  Perhaps there's a problem with the network connection?" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
  }];
}

- (IBAction)cancel:(id)sender
{
  [self.delegate dismissSignupViewController];
}

@end
