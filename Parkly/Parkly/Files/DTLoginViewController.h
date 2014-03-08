//
//  DTLoginViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 3/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)logIn:(id)sender;
- (IBAction)tap:(id)sender;

@end
