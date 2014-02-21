//
//  DTSignupViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSignupViewControllerDelegate <NSObject>

//Methods needed for singup delegate

@end

@interface DTSignupViewController : UIViewController
- (IBAction)didPressSignupButton:(id)sender;
- (IBAction)didPressCancelButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *birthdayMonthField;
@property (strong, nonatomic) IBOutlet UITextField *birthdayDayField;
@property (strong, nonatomic) IBOutlet UITextField *birthdayYearField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;

@end
