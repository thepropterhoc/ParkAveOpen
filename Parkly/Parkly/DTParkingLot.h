//
//  DTParkingLot.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTParkingLot : NSObject

//These properties correspond to the email sent out declaring the data stored in the webserver.  The types simply reflect a best guess as to the type of data each will contain. 

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *__v;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lon;

@property (strong, nonatomic) NSDictionary* address;

@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *pavementType;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSNumber *minimumPrice;

#warning Need to be implemented
@property (strong, nonatomic) NSNumber *averageRating;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSString *lotImage;

- (NSDictionary*) dictionaryRepresentation;

@end