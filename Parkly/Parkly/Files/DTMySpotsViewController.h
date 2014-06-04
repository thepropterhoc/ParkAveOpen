//
//  DTMySpotsViewController.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 6/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTMySpotsViewControllerDelegate <NSObject>

-(void)dismissMySpotsViewController;

@end

@interface DTMySpotsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<DTMySpotsViewControllerDelegate> delegate;

@end
