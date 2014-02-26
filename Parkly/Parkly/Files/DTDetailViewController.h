//
//  DTDetailViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDetailViewController : UIViewController
- (IBAction)bookSpot:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lotTitle;
@property (strong, nonatomic) IBOutlet UILabel *lotOwner;
@property (strong, nonatomic) IBOutlet UILabel *distanceToVenue;
@property (strong, nonatomic) IBOutlet UILabel *surfaceType;
@property (strong, nonatomic) IBOutlet UILabel *averageReview;



@end
