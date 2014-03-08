//
//  DTReviewTableViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTUser.h"

@interface DTReviewTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DTUser *theUser;
@property (strong, nonatomic) NSString *userID;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
