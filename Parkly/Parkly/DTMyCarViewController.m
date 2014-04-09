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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DTMyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  [cell initWithCar:[[DTModel sharedInstance] defaultCar]];
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
  
#warning Cars not implemented correctly here
  [[DTModel sharedInstance] setDefaultCar:[[DTModel sharedInstance] defaultCar]];
  [self.delegate dismissMyCarViewController];
}

@end
