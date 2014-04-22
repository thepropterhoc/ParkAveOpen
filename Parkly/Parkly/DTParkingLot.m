//
//  DTParkingLot.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTParkingLot.h"

@implementation DTParkingLot

- (id) init {
  self = [super init];
  if (self) {
    self._id = [[NSString alloc] init];
    self.__v = [[NSString alloc] init];
    self.user_id = [[NSString alloc] init];
    self.title = [[NSString alloc] init];
    self.lat = [[NSString alloc] init];
    self.lon = [[NSString alloc] init];
    self.address = [[NSDictionary alloc] init];
    self.address1 = [[NSString alloc] init];
    self.address2 = [[NSString alloc] init];
    self.city = [[NSString alloc] init];
    self.state = [[NSString alloc] init];
    self.zip = [[NSString alloc] init];
    self.lotImage = [[NSString alloc] init];
    self.imagePath = [[NSString alloc] init];
    self.minimumPrice = [[NSNumber alloc] init];
    self.pavementType = [[NSString alloc] init];
    self.averageRating = [[NSNumber alloc] init];
    self.distance = [[NSNumber alloc] init];
  }
  return self;
}

- (NSDictionary*) dictionaryRepresentation {
  return @{
           @"_id": self._id,
           @"__v": self.__v,
           @"user_id": self.user_id,
           @"title": self.title,
           @"model": self.lat,
           @"year": self.lon,
           @"address": self.address,
           @"address1": self.address1,
           @"address2": self.address2,
           @"city": self.city,
           @"state": self.state,
           @"zip": self.zip,
           @"lotImage": self.lotImage,
           @"imagePath": self.imagePath,
           @"minimumPrice": self.minimumPrice,
           @"pavementType": self.pavementType,
           @"averageRating": self.averageRating,
           @"distance": self.distance
           };
}


@end