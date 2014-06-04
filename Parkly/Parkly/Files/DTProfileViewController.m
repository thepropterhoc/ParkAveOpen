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
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

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
    [self fillFields:[[DTModel sharedInstance] currentUser]];
  }
    // Do any additional setup after loading the view.
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
  [self.phoneField resignFirstResponder];
  [self.emailField resignFirstResponder];
  [self.passwordField resignFirstResponder];
  [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)fillFields:(DTUser*)user
{
  [self.firstNameField setText:user.firstName];
  [self.lastNameField setText:user.lastName];
  [self.phoneField setText:user.phone];
  [self.emailField setText:user.email];
  [self.passwordField setText:user.password];
}

-(DTUser*)userFromFields
{
  DTUser *newUser = [[DTModel sharedInstance] currentUser];
  if(!newUser){
    newUser = [[DTUser alloc] init];
  }
  newUser.firstName = self.firstNameField.text;
  newUser.lastName = self.lastNameField.text;
  newUser.phone = self.phoneField.text;
  newUser.email = self.emailField.text;
  newUser.password = self.passwordField.text;
  newUser.reservedSpots = @[];
  newUser.spotHistory = @[];
  newUser.averageRating = @0;
  newUser.creditCard = @"";
  /*
  @"firstName": self.firstName,
  @"lastName": self.lastName,
  @"email": self.email,
  @"password": self.password,
  //@"birthdate": self.birthdate,
  //@"phone": self.phone,
  @"reservedSpots": self.reservedSpots,
  @"spotHistory": self.spotHistory,
  @"averageRating": self.averageRating,
  @"creditCard": self.creditCard
   */
  return newUser;
}

- (IBAction)done:(id)sender
{
  [self.delegate dismissProfileViewController:self];
}

- (IBAction)save:(id)sender
{
  /*
  if(![[DTModel sharedInstance] currentUser]){
    [[DTModel sharedInstance] createUser:[self userFromFields] success:^(NSURLSessionDataTask *task, DTUser *newUser) {
      [[[UIAlertView alloc] initWithTitle:@"Aww yiss" message:@"Successfully created new user" delegate:nil cancelButtonTitle:@"Bueno" otherButtonTitles: nil] show];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      [[[UIAlertView alloc] initWithTitle:@"Houston, we have a problem" message:@"Something went terribly wrong" delegate:nil cancelButtonTitle:@"Panic" otherButtonTitles: nil] show];
    }];
  } else {
    [[DTModel sharedInstance] updateUser:[self userFromFields] success:^(NSURLSessionDataTask *task, id responseObject) {
      [[[UIAlertView alloc] initWithTitle:@"Aww yiss" message:@"Successfully updated info" delegate:nil cancelButtonTitle:@"Bueno" otherButtonTitles: nil] show];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      [[[UIAlertView alloc] initWithTitle:@"Houston, we have a problem" message:@"Something went terribly wrong" delegate:nil cancelButtonTitle:@"Panic" otherButtonTitles: nil] show];
    }];
  }
   */
}


@end
