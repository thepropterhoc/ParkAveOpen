//
//  DTProfileViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 3/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTProfileViewController.h"
#import "DTModel.h"

@interface DTProfileViewController ()

@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allFields;


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
  self.dateOfBirthField.text = self.theUser.birthdate;
  self.phoneField.text = self.theUser.phone;
}

-(DTUser*)updatedUserInfo
{
  DTUser *newUser = self.theUser;
  newUser.firstName = self.firstNameField.text;
  newUser.lastName = self.lastNameField.text;
  newUser.email = self.usernameField.text;
  newUser.birthdate = self.dateOfBirthField.text;
  newUser.phone = self.phoneField.text;
  return newUser;
}

- (IBAction)done:(id)sender
{
  [self.delegate dismissProfileViewControllerSuccess];
  [[DTModel sharedInstance] updateUser:[self updatedUserInfo] success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"Successfully updated user's info");
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Unable to update user info.  Check the network connection?" delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
  }];
  if([[DTModel sharedInstance] userIsLoggedIn]){
    NSLog(@"User has updated info and successfully logged in");
  }
}

- (IBAction)cancel:(id)sender
{
  [self.delegate dismissProfileViewControllerCanceled];
}

- (IBAction)tap:(id)sender {
  [self.firstNameField resignFirstResponder];
  [self.lastNameField resignFirstResponder];
  [self.usernameField resignFirstResponder];
  [self.dateOfBirthField resignFirstResponder];
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
