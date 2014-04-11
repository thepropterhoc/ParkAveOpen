//
//  DTMyCarViewController.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 4/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAddACarViewController.h"

@protocol DTMyCarViewControllerDelegate <NSObject>

-(void)dismissMyCarViewController;

@end

@interface DTMyCarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DTAddACarViewControllerDelegate>

@property (weak, nonatomic) id<DTMyCarViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *theTable;

@end
