//
//  DTUser.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTUser.h"

@implementation DTUser


- (NSDictionary*) dictionaryRepresentation {
    return @{@"_id": self._id,
             @"firstName": self.firstName,
             @"lastName": self.lastName,
             @"email": self.email,
             @"password": self.password,
             @"birthdate": self.birthdate,
             @"phone": self.phone,
             @"reservedSpots": self.reservedSpots,
             @"spotHistory": self.spotHistory,
             };
}

@end