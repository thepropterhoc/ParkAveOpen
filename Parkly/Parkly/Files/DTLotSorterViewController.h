//
//  DTLotSorterViewController.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/20/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTSpotTableViewCell.h"
#import "DTProfileViewController.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface DTLotSorterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DTSpotTableViewCellDelegate, DTProfileViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)segmentedControlDidSelect:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
