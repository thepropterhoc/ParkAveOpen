//
//  DTLotExpandedTableViewCell.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/20/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSpotTableViewCell.h"
#import "DTParkingLot.h"

@interface DTLotExpandedTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

-(void)initWithLot:(DTParkingLot*)lot;
@property (strong, nonatomic) IBOutlet UILabel *lotNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *reviewsButton;
@property (strong, nonatomic) IBOutlet UIButton *theImage;
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) id<DTSpotTableViewCellDelegate> passthrough;

@end
