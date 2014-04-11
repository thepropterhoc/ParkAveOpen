//
//  DTAddACarViewController.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 4/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCar.h"

@protocol DTAddACarViewControllerDelegate <NSObject>

-(void)dismissAddACarViewControllerWithCar:(DTCar*)car;
-(void)dismissAddACarViewController;

@end

@interface DTAddACarViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *makeField;
@property (strong, nonatomic) IBOutlet UITextField *modelField;
@property (strong, nonatomic) IBOutlet UITextField *yearField;
@property (strong, nonatomic) IBOutlet UITextField *colorField;
@property (strong, nonatomic) IBOutlet UITextField *tagField;
@property (strong, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) id<DTAddACarViewControllerDelegate> delegate;

@end
