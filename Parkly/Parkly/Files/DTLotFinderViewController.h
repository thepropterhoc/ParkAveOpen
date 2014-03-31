//
//  DTLotFinderViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DTLotTableViewController.h"
#import "DTProfileViewController.h"
#import "DTSignupViewController.h"
#import "DTLoginViewController.h"

@interface DTLotFinderViewController : UIViewController <MKMapViewDelegate, DTLotTableViewControllerDelegate, DTProfileViewControllerDelegate, DTLoginViewControllerDelegate, DTSignupViewControllerDelegate>


@property (strong, nonatomic) IBOutlet MKMapView *theMap;
- (IBAction)didSelectSegment:(UISegmentedControl *)sender;

@end
