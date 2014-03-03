//
//  DTProfileViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 3/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTUser.h"

@protocol DTProfileViewControllerDelegate <NSObject>

-(void)dismissProfileViewControllerSuccess;
-(void)dismissProfileViewControllerCanceled;

@end

@interface DTProfileViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id<DTProfileViewControllerDelegate> delegate;

-(void)initWithUser:(DTUser*)user;

@end
