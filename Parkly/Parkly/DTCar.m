//
//  DTCar.m
//  Parkly
//
//  Created by CCEW on 3/3/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTCar.h"
#import "DTUser.h"

@implementation DTCar

- (id) initWithUser:(DTUser*)user {
    self = [super init];
    if (self) {
        self._id = [[NSString alloc] init];
        self.__v = [[NSString alloc] init];
        self.user_id = [user _id];
        self.make = [[NSString alloc] init];
        self.model = [[NSString alloc] init];
        self.year = [[NSString alloc] init];
        self.plate = [[NSString alloc] init];
        self.state = [[NSString alloc] init];
        self.color = [[NSString alloc] init];
    }
    return self;
    
}

- (NSDictionary*) dictionaryRepresentation {
    
    return @{
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
