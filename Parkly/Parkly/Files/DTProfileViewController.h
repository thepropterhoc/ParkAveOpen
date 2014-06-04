//
//  DTProfileViewController.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 6/1/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTProfileViewControllerDelegate <NSObject>

-(void)dismissProfileViewController:(id) profile;

@end

@interface DTProfileViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id<DTProfileViewControllerDelegate> delegate;

@end
