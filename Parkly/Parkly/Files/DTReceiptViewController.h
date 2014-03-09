//
//  DTReceiptViewController.h
//  Parkly
//
//  Created by Shelby Vanhooser on 3/9/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DTReceiptViewController : UIViewController

@property (strong, nonatomic) NSString *theReceipt;
@property (strong, nonatomic) MKMapItem *theItem;

@end
