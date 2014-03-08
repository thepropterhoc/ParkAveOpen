//
//  DTReviewTableViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTReviewTableViewController.h"
#import "DTReviewTableCell.h"
#import "DTUser.h"
#import "DTModel.h"

@interface DTReviewTableViewController ()

@property (strong, nonatomic) NSArray *reviews;

@end

@implementation DTReviewTableViewController

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
  [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View implementation methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.reviews count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"cell";
  DTReviewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  [cell initWithReview:self.reviews[indexPath.row]];
  return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DTReview *review = self.reviews[indexPath.row];
  return MAX(120.0, [self heightForText:review.body]);
  //return 60.0 + [self heightForText:review.body];
}

-(CGFloat)heightForText:(NSString *)text
{
  UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 228, 600)];
  textView.text = text;
  textView.font = [UIFont fontWithName:@"AvenirNext-MediumItalic" size:14.0f];
  [textView sizeToFit];
  return textView.frame.size.height;
}

#pragma mark - Data Fetching and populating methods

-(void)refreshData
{
  [[DTModel sharedInstance] getUserWithId:self.userID success:^(NSURLSessionDataTask *task, DTUser *user) {
    [[DTModel sharedInstance] getReviewsForUser:user success:^(NSURLSessionDataTask *task, id responseObject) {
      self.reviews = responseObject;
      [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      self.reviews = nil;
      [self.tableView reloadData];
      [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to fetch reviews.  Check the network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
  }];
}

@end
