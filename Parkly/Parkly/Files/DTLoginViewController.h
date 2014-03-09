//
//  DTLoginViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTLoginViewControllerDelegate <NSObject>

-(void)dismissLoginViewController;

@end

@interface DTLoginViewController : UIViewController

@property (weak, nonatomic) id<DTLoginViewControllerDelegate> delegate;

@end
