//
//  DTTableViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTTableViewControllerDelegate <NSObject>

-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface DTTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak) id <DTTableViewControllerDelegate> delegate;

@end