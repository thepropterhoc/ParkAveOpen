//
//  DTLoginViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLoginViewController.h"
#import "DTModel.h"
#import "DTUser.h"

@interface DTLoginViewController ()

@end

@implementation DTLoginViewController

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"profile"]){
        
    }
}

- (IBAction)loginButtonPressed:(id)sender
{
    if(![[DTModel sharedInstance] defaultsExist]) {
        [[DTModel sharedInstance] authenticateUser:@"jrohan@yahoo.com" withPassword:@"soba" success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"Hello, %@", [[[DTModel sharedInstance] currentUser] firstName]);
            [self performSegueWithIdentifier:@"goToMain" sender:self];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [[DTModel sharedInstance] authenticateUser:[[DTModel sharedInstance] defaultEmail] withPassword:[[DTModel sharedInstance] defaultPassword] success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"Welcome back, %@", [[[DTModel sharedInstance] currentUser] firstName]);
            [self performSegueWithIdentifier:@"goToMain" sender:self];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
    }

}

@end
