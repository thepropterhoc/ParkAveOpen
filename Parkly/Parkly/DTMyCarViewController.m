//
//  DTMyCarViewController.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 4/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTMyCarViewController.h"
#import "DTMyCarTableViewCell.h"
#import "DTModel.h"

@interface DTMyCarViewController ()

@property (strong, nonatomic) NSArray *theCars;

@end

@implementation DTMyCarViewController

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
  [[DTModel sharedInstance] getCarsForUser:[[DTModel sharedInstance] currentUser] success:^(NSURLSessionDataTask *task, NSArray *cars) {
    self.theCars = cars;
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    self.theCars = nil;
  }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if(self.theCars){
    return [self.theCars count];
  } else {
    return 0;
  }
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DTMyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  [cell initWithCar:self.theCars[indexPath.row]];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [[tableView cellForRowAtIndexPath:indexPath] setEditing:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO];
}

- (IBAction)setDefaultCar:(id)sender
{
  if(self.theTable.indexPathForSelectedRow){
    [[DTModel sharedInstance] setDefaultCar:self.theCars[[self.theTable indexPathForSelectedRow].row]];
    [self.delegate dismissMyCarViewController];
  } else {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No car selected" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"pushToAddACar"]){
    DTAddACarViewController *dest = [segue destinationViewController];
    dest.delegate = self;
  }
}

- (IBAction)addACar:(id)sender
{
  [self performSegueWithIdentifier:@"pushToAddACar" sender:self];
}

-(void)dismissAddACarViewController
{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

-(void)dismissAddACarViewControllerWithCar:(DTCar *)car
{
  self.theCars = [self.theCars arrayByAddingObject:car];
  [self.theTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.theCars.count inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self dismissAddACarViewController];
}

@end
