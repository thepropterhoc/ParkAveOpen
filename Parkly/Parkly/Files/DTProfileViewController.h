//
//  DTProfileViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 3/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTMyCarViewController.h"
#import "DTUser.h"

@protocol DTProfileViewControllerDelegate <NSObject>

-(void)dismissProfileViewControllerSuccess;
-(void)dismissProfileViewControllerCanceled;

@end

@interface DTProfileViewController : UIViewController <UITextFieldDelegate, DTMyCarViewControllerDelegate>

@property (weak, nonatomic) id<DTProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) DTUser *theUser;

@end
