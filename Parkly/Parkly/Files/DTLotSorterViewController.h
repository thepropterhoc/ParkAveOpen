//
//  DTLotSorterViewController.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/20/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTSpotTableViewCell.h"

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface DTLotSorterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DTSpotTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet MKMapView *theMap;

@end
