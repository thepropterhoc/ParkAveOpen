//
//  DTProfileViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 3/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTProfileViewController.h"

@interface DTProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *monthField;
@property (strong, nonatomic) IBOutlet UITextField *dayField;
@property (strong, nonatomic) IBOutlet UITextField *yearField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;

@property CGRect startFrame;

@end

@implementation DTProfileViewController

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
  self.startFrame = self.view.frame;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithUser:(DTUser *)user
{
  
}

-(DTUser*)updatedUserInfo
{
  DTUser *newUser = [[DTUser alloc] init];
  newUser.name = self.nameField.text;
  newUser.username = self.usernameField.text;
  newUser.password = self.passwordField.text;
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setMonth:[self.monthField.text integerValue]];
  [components setDay:[self.dayField.text integerValue]];
  [components setYear:[self.dayField.text integerValue]];
  newUser.dateOfBirth = [components date];
  newUser.phone = self.phoneField.text;
  return newUser;
}

- (IBAction)done:(id)sender
{
  [self.delegate dismissProfileViewControllerSuccess];
#warning Need to update the model with the user info with [self updatedUserInfo];
}

- (IBAction)cancel:(id)sender
{
  [self.delegate dismissProfileViewControllerCanceled];
}

- (IBAction)tap:(id)sender {
  [self.nameField resignFirstResponder];
  [self.usernameField resignFirstResponder];
  [self.passwordField resignFirstResponder];
  [self.monthField resignFirstResponder];
  [self.dayField resignFirstResponder];
  [self.yearField resignFirstResponder];
  [self.phoneField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self.view setFrame:CGRectMake(0,  -1 * textField.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
  [self.view setFrame:self.startFrame];
}

@end
