//
//  DTCar.m
//  Parkly
//
//  Created by CCEW on 3/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTCar.h"

@implementation DTCar
- (NSDictionary*) dictionaryRepresentation {
    
    return @{
             @"_id": self._id,
             @"__v": self.__v,
             @"user_id": self.user_id,
             @"make": self.make,
             @"model": self.model,
             @"year": self.year,
             @"plate": self.plate,
             @"state": self.state,
             @"color": self.color,
             };
}

@end
