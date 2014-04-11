//
//  DTAddACarViewController.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 4/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTAddACarViewController.h"
#import "DTModel.h"

@interface DTAddACarViewController ()

@end

@implementation DTAddACarViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self.scrollView setFrame:CGRectMake(0, 150 + (textField.frame.origin.y * -1), self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

- (IBAction)tap:(id)sender
{
  [self.makeField resignFirstResponder];
  [self.modelField resignFirstResponder];
  [self.yearField resignFirstResponder];
  [self.colorField resignFirstResponder];
  [self.tagField resignFirstResponder];
  [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

- (IBAction)cancel:(id)sender
{
  [self.delegate dismissAddACarViewController];
}

- (IBAction)add:(id)sender
{
  DTCar *defaultCar = [[DTCar alloc] init];
  [defaultCar setYear:self.yearField.text];
  [defaultCar setMake:self.makeField.text];
  [defaultCar setModel:self.modelField.text];
  [defaultCar setColor:self.colorField.text];
  [defaultCar setPlate:self.tagField.text];
  
  [[DTModel sharedInstance] setDefaultCar:defaultCar];
  [self.delegate dismissAddACarViewController];
}

@end
