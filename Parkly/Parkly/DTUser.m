//
//  DTUser.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/21/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTUser.h"

@implementation DTUser

- (id) init {
    self = [super init];
    if (self) {
        self._id = [[NSString alloc] init];
        self.__v = [[NSString alloc] init];
        self.firstName = [[NSString alloc] init];
        self.lastName = [[NSString alloc] init];
        self.email = [[NSString alloc] init];
        self.password = [[NSString alloc] init];
        self.birthdate = [[NSString alloc] init];
        self.phone = [[NSString alloc] init];
        self.reservedSpots = [[NSArray alloc] init];
        self.spotHistory = [[NSArray alloc] init];
        self.averageRating = [[NSNumber alloc] init];
        self.creditCard = [[NSString alloc] init];
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"firstName": self.firstName,
             @"lastName": self.lastName,
             @"email": self.email,
             @"password": self.password,
             @"birthdate": self.birthdate,
             @"phone": self.phone,
             @"reservedSpots": self.reservedSpots,
             @"spotHistory": self.spotHistory,
             @"averageRating": self.averageRating,
             @"creditCard": self.creditCard
             };
}

@end