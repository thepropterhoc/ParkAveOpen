//
//  DTParkingSpot.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTParkingSpot : NSObject

//These properties correspond to the email sent out declaring the data stored in the webserver.  The types simply reflect a best guess as to the type of data each will contain. 

@property (strong, nonatomic) NSString *lotID;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *numSpots;
@property (strong, nonatomic) NSArray *buyerIDs;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *eventID;

@end