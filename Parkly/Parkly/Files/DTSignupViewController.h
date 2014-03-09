//
//  DTSignupViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 3/9/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSignupViewControllerDelegate <NSObject>

-(void)dismissSignupViewController;

@end

@interface DTSignupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id<DTSignupViewControllerDelegate> delegate;

@end
