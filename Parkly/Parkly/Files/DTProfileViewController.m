//
//  DTProfileViewController.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 6/1/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTModel.h"
#import "DTProfileViewController.h"

@interface DTProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;

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
  if([[DTModel sharedInstance] currentUser]){
    [self returningUserConfig];
  } else if(![[DTModel sharedInstance] defaultUser]){
    [self newUserConfig];
  } else {
    [self loginConfig];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
  [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 40) animated:YES];
}

- (IBAction)tap:(id)sender
{
  [self.firstNameField resignFirstResponder];
  [self.lastNameField resignFirstResponder];
  [self.emailField resignFirstResponder];
  [self.passwordField resignFirstResponder];
  [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)fillFields:(DTUser*)user
{
  [self.firstNameField setText:user.firstName];
  [self.lastNameField setText:user.lastName];
  [self.emailField setText:user.email];
}

-(DTUser*)userFromFields
{
  DTUser *newUser = [[DTModel sharedInstance] currentUser];
  if(!newUser){
    newUser = [[DTUser alloc] init];
  }
  newUser.firstName = self.firstNameField.text;
  newUser.lastName = self.lastNameField.text;
  newUser.email = self.emailField.text;
  newUser.password = self.passwordField.text;
  newUser.reservedSpots = @[];
  newUser.spotHistory = @[];
  newUser.averageRating = @0;
  newUser.creditCard = @"";
  return newUser;
}

-(DTUser*) loginUserFromFields
{
  DTUser* newUser = [[DTUser alloc] init];
  newUser.email = self.emailField.text;
  newUser.password = self.passwordField.text;
  return newUser;
}

- (IBAction)done:(id)sender
{
  [self.delegate dismissProfileViewController:self];
}

-(void) newUserConfig
{
  [self.navigationItem setPrompt:@"create an account"];
  [self.actionButton setTitle:@"Sign Up"];
  [[[UIAlertView alloc] initWithTitle:@"Why, hello there" message:@"Create an account with us, yeah?" delegate:nil cancelButtonTitle:@"Let's go" otherButtonTitles:nil] show];
  [self.logOutButton setEnabled:NO];
  [self.logOutButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
}

-(void) returningUserConfig
{
  [self.navigationItem setPrompt:@"update your info"];
  [self.actionButton setTitle:@"Update"];
  [self fillFields:[[DTModel sharedInstance] currentUser]];
  [self.logOutButton setEnabled:YES];
  [self.logOutButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
}

-(void)loginConfig
{
  [self.navigationItem setPrompt:@"input email/password"];
  [self.actionButton setTitle:@"Log In"];
  [self.firstNameLabel setHidden:YES];
  [self.lastNameLabel setHidden:YES];
  [self.firstNameField setHidden:YES];
  [self.lastNameField setHidden:YES];
  [self.logOutButton setEnabled:NO];
  [self.logOutButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
}

-(BOOL)createFieldsOK
{
  return ![self.firstNameField.text isEqualToString:@""] && ![self.lastNameField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""];
}

-(BOOL)updateFieldsOK
{
  return ![self.firstNameField.text isEqualToString:@""] && ![self.lastNameField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""];
}

-(BOOL)loginFieldsOK
{
  return ![self.emailField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString: @""];
}

- (IBAction)actionButtonTapped:(id)sender
{
  if(![[DTModel sharedInstance] currentUser] && ![[DTModel sharedInstance] defaultUser]){
    //Create
    if(![self createFieldsOK]){
      [[[UIAlertView alloc] initWithTitle:@"No bueno" message:@"Please input correct data into fields" delegate:nil cancelButtonTitle:@"Try it again" otherButtonTitles: nil] show];
      return;
    }
    [[DTModel sharedInstance] createUser:[self userFromFields] success:^(NSURLSessionDataTask *task, DTUser *newUser) {
      [[DTModel sharedInstance] setCurrentUser:newUser];
      [[DTModel sharedInstance] setDefaultUser:newUser];
      [[[UIAlertView alloc] initWithTitle:@"Aww yiss" message:@"Successfully created new user" delegate:nil cancelButtonTitle:@"Bueno" otherButtonTitles: nil] show];
      [self.delegate dismissProfileViewController:self];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      [[[UIAlertView alloc] initWithTitle:@"Houston, we have a problem" message:@"Something went terribly wrong" delegate:nil cancelButtonTitle:@"Panic" otherButtonTitles: nil] show];
    }];
  } else if([[DTModel sharedInstance] currentUser] && [[DTModel sharedInstance] defaultUser]){
    //Update
    if(![self updateFieldsOK]){
      [[[UIAlertView alloc] initWithTitle:@"No bueno" message:@"Please input correct data and password into fields" delegate:nil cancelButtonTitle:@"Try it again" otherButtonTitles: nil] show];
      return;
    }
    [[DTModel sharedInstance] updateUser:[self userFromFields] success:^(NSURLSessionDataTask *task, id responseObject) {
      [[[UIAlertView alloc] initWithTitle:@"Aww yiss" message:@"Successfully updated info" delegate:nil cancelButtonTitle:@"Bueno" otherButtonTitles: nil] show];
      [self.delegate dismissProfileViewController:self];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      [[[UIAlertView alloc] initWithTitle:@"Houston, we have a problem" message:@"Something went terribly wrong" delegate:nil cancelButtonTitle:@"Panic" otherButtonTitles: nil] show];
    }];
  } else {
    //Login
    if(![self loginFieldsOK]){
      [[[UIAlertView alloc] initWithTitle:@"No bueno" message:@"Please input email/password" delegate:nil cancelButtonTitle:@"Try it again" otherButtonTitles: nil] show];
      return;
    }
    [[DTModel sharedInstance] authenticateUser:[self loginUserFromFields] success:^(NSURLSessionDataTask *task, DTUser *aUser) {
      [[[UIAlertView alloc] initWithTitle:@"Aww yiss" message:@"Ya done logged in" delegate:nil cancelButtonTitle:@"Cheers" otherButtonTitles: nil] show];
      [self.delegate dismissProfileViewController:self];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      [[[UIAlertView alloc] initWithTitle:@"Ack!" message:@"Wait, I couldn't log you in... Are you lying to me?" delegate:nil cancelButtonTitle:@"If you insist" otherButtonTitles: nil] show];
    }];
  }
}

- (IBAction)logOut:(id)sender
{
  [[DTModel sharedInstance] logoutUserWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
    [[[UIAlertView alloc] initWithTitle:@"Later, man" message:@"I'm sad to see you go" delegate:nil cancelButtonTitle:@"I might be back" otherButtonTitles: nil] show];
    [self.delegate dismissProfileViewController:self];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [[[UIAlertView alloc] initWithTitle:@"Yikes!" message:@"You probably just caught a server on fire trying to log out.  Don't worry, it's all under control." delegate:nil cancelButtonTitle:@"Uh, ok?" otherButtonTitles: nil] show];
  }];
}


@end
