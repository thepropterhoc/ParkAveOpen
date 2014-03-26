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

@property (strong, nonatomic) IBOutlet UIScrollView *theScrollView;

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
  [self.theScrollView setContentSize:CGSizeMake(320, 800)];
  NSLog(@"Frame : %.f, %.f, %.f, %.f\nContent : %.f, %.f", self.theScrollView.frame.origin.x
        , self.theScrollView.frame.origin.y, self.theScrollView.frame.size.width, self.theScrollView.frame.size.height, self.theScrollView.contentSize.width, self.theScrollView.contentSize.height);
  [self.theScrollView setScrollEnabled:YES];
  //[self.theScrollView setBounds:self.theScrollView.frame];
  
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
  
  theUser.averageRating = [[NSNumber alloc] initWithInt:0];
  
  return theUser;
}

- (IBAction)signup:(id)sender
{
  [[DTModel sharedInstance] createUser:[self userFromFields] success:^(NSURLSessionDataTask *task, DTUser *newUser) {
    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully created an account.  Welcome to Park Ave." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show
     ];
    [self.delegate dismissSignupViewController];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error creating an account.  Perhaps there's a problem with the network connection?" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
  }];
}

- (IBAction)cancel:(id)sender
{
  [self.delegate dismissSignupViewController];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self.theScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 30.0f) animated:YES];
}
- (IBAction)tap:(id)sender
{
  [self.firstNameField resignFirstResponder];
  [self.lastNameField resignFirstResponder];
  [self.emailField resignFirstResponder];
  [self.passwordField resignFirstResponder];
  [self.monthField resignFirstResponder];
  [self.dayField resignFirstResponder];
  [self.yearField resignFirstResponder];
  [self.phoneField resignFirstResponder];
  [self.theScrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

@end
