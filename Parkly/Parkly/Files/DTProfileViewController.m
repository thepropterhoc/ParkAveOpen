//
//  DTProfileViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 3/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTProfileViewController.h"

@interface DTProfileViewController ()

@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *monthField;
@property (strong, nonatomic) IBOutlet UITextField *dayField;
@property (strong, nonatomic) IBOutlet UITextField *yearField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allFields;

@property (strong, nonatomic) IBOutlet UIButton *editButton;

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
  if(self.theUser){
    [self fillWithUpdatedUserInfo];
  }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillWithUpdatedUserInfo
{
  self.firstNameField.text = self.theUser.firstName;
  self.lastNameField.text = self.theUser.lastName;
  self.usernameField.text = self.theUser.email;
}

-(DTUser*)updatedUserInfo
{
  DTUser *newUser = [[DTUser alloc] init];
  newUser.firstName = self.firstNameField.text;
  newUser.lastName = self.lastNameField.text;
  //newUser.username = self.usernameField.text;
  newUser.password = self.passwordField.text;
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:@"gregorian"]];
  [components setMonth:[self.monthField.text integerValue]];
  [components setDay:[self.dayField.text integerValue]];
  [components setYear:[self.yearField.text integerValue]];
  //[components setMinute:0];
  //[components setHour:0];
  //[components setSecond:0];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"YYYY-MM-DD'T'HH:MMZ"];
  NSLog(@"date : %@", [formatter stringFromDate:[components date]]);
#warning Fix date formatting here
  
  newUser.phone = self.phoneField.text;
  return newUser;
}

- (IBAction)done:(id)sender
{
  [self.delegate dismissProfileViewControllerSuccess];
  NSLog(@"%@", [self updatedUserInfo]);
#warning Need to update the model with the user info with [self updatedUserInfo];
}

- (IBAction)cancel:(id)sender
{
  [self.delegate dismissProfileViewControllerCanceled];
}

- (IBAction)tap:(id)sender {
  [self.firstNameField resignFirstResponder];
  [self.lastNameField resignFirstResponder];
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
