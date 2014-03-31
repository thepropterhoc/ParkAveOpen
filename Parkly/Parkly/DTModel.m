//
//  DTModel.m
//  Parkly
//
//  Created by CCEW on 2/24/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTModel.h"
#import "PDKeychainBindings.h"

@interface DTModel ()

@property (weak, nonatomic) DTDataManager* dataManager;
@property (weak, nonatomic) DTNetworkManager* networkManager;

- (NSArray*) parseJSON:(id)json toArrayOfClass:(__unsafe_unretained Class)theClass;
- (void) setDefaultEmail:(NSString*)email;

@end

@implementation DTModel

+ (instancetype)sharedInstance {
    //  Static local predicate must be initialized to 0
    static DTModel *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
        
        // Do any other initialisation stuff here
        sharedInstance.dataManager = [DTDataManager sharedInstance];
        sharedInstance.networkManager = [DTNetworkManager sharedInstance];
    });
    return sharedInstance;
}

#pragma mark - Local User Session
- (void) logoutUser {
    [self.dataManager logoutUser];
}
- (BOOL) userIsLoggedIn {
    return [self.dataManager isUserLoggedIn];
}
- (BOOL) userHasAccount {
    return [self defaultsExist];
}

#pragma mark - Users

- (void) authenticateUserWithEmail:(NSString*)email andPassword:(NSString*)password success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary* parameters = @{@"email": email,
                                 @"password": password};
    
    NSLog(@"%@",parameters);
    
    [self.networkManager call:@"post" one:@"users" two:@"session" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                   NSLog(@"we're doin' it");
        NSLog(@"%@",responseObject);
        if([[responseObject valueForKey:@"err"] isEqualToString:@"nomatch"]) {
            responseObject = @"error";
        } else {
            [[[self dataManager] currentUser] setValuesForKeysWithDictionary:responseObject];
            //set the defaults for next time if they aren't the same
                [self setDefaultEmail:email];
                [[PDKeychainBindings sharedKeychainBindings] setString:password forKey:@"password"];
                NSLog(@"default email: %@. You're logged in.", [self defaultEmail]);
        }
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) authenticateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* aUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self authenticateUserWithEmail:[user email] andPassword:[user password] success:^(NSURLSessionDataTask *task, DTUser *user) {
        success(task, user);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) getAllUsers: (void (^)(NSURLSessionDataTask *task, NSArray* allUsers))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self.networkManager call:@"get" one:@"users" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, [self parseJSON:responseObject toArrayOfClass:[DTUser class]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) getUserWithId:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self.networkManager call:@"get" one:@"users" two:userID parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DTUser* newUser = [[DTUser alloc] init];
        NSLog(@"%@", responseObject);
        [newUser setValuesForKeysWithDictionary:responseObject];
        success(task, newUser);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) createUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* newUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[self networkManager] call:@"post" one:@"users" parameters:[user dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
      NSLog(@"Response object from creation of user: %@", responseObject);
      /*DTUser* newUser = [[DTUser alloc] init];
      [newUser setValuesForKeysWithDictionary:responseObject];*/
        //Login with that new user
        [self authenticateUser:user success:^(NSURLSessionDataTask *task, DTUser *aUser) {
            success(task, user);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
          //Login with that new user
          NSLog(@"Failed to authenticate new user");
            failure(task, error);
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"New user : %@", [user dictionaryRepresentation]);
        failure(task, error);
    }];
}

- (void) updateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[self networkManager] call:@"put" one:@"users" two:[user _id] parameters:[user dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
     success(task, responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
     failure(task, error);
     }];
}

- (void) deleteUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[self networkManager] call:@"delete" one:@"users" two:[user _id] parameters:[user dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
     success(task, responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
     failure(task, error);
     }];
}

#pragma mark - Lots

- (void) getAllLots: (void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
    if([[DTCache sharedInstance] hasLots]){
      success(nil, [[DTCache sharedInstance] allLots]);
      return;
    }
  
    [self.networkManager call:@"get" one:@"lots" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      
        NSArray *resultArray = [self parseJSON:responseObject toArrayOfClass:[DTParkingLot class]];
      
        [[DTCache sharedInstance] addLots:resultArray];
      
        success(task, resultArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) getLotsNearLatitude:(CGFloat*)latitude andLongitude:(CGFloat*)longitude success:(void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
#warning fix this later
    [self getAllLots:success failure:failure];
}

- (void) getLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) createLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) updateLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) deleteLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

#pragma mark - Spots

- (void) getSpotsForLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, NSArray* spots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //0. check if we already have the spots in memory
    //1. create parameters dictionary
    //2. call network manager
    //3.1   if success, parse spots into DTParkingSpot array
    //      update data manager
    //3.2   if failure, return error
    
    //0
    
    //1
    //NSDictionary* parameters = [NSDictionary dictionaryWithObject:lotID forKey:@"_id"];
    
    //2
  
    if([[DTCache sharedInstance] hasSpotsForLot:lot]){
      success(nil, [[DTCache sharedInstance] spotsForLot:lot]);
      return;
    }
  
    [self.networkManager call:@"get" one:@"users" two:[lot user_id] three:@"lots" four:[lot _id] five:@"spots" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //if success, first parse JSON into objects
        NSArray* spotArray = [self parseJSON:responseObject toArrayOfClass:[DTParkingSpot class]];
        //update the dataManager
        //[self.dataManager updateSpots:spotArray withLotId:lotID];
      
      [[DTCache sharedInstance] addSpots:spotArray forLot:lot];
      
        //do whatever the user wants with the array of spots
        success(task, spotArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //bubble up the error
        failure(task, error);
    }];
}

- (void) getSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) createSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) updateSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) deleteSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

#pragma mark - Cars

- (void) getCarsForUser:(DTUser *)user success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [self.networkManager call:@"get" one:@"users" two:[user _id] three:@"cars" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, [self parseJSON:responseObject toArrayOfClass:[DTCar class]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) getCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) createCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self.networkManager call:@"post" one:@"users" two:[car user_id] three:@"cars" parameters:[car dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) updateCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self.networkManager call:@"post" one:@"users" two:[car user_id] three:@"cars" four:[car _id] parameters:[car dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) deleteCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self.networkManager call:@"delete" one:@"users" two:[car user_id] three:@"cars" four:[car _id] parameters:[car dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}
#pragma mark - Reviews

- (void) getAllReviews: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self.networkManager call:@"get" one:@"reviews" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) getReviewsForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSArray* reviews))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@", user._id);
    [self.networkManager call:@"get" one:@"users" two:[user _id] three:@"reviews" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, [self parseJSON:responseObject toArrayOfClass:[DTReview class]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void) getReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) createReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) updateReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) deleteReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

#pragma mark - Purchase

- (void) purchaseSpot:(DTParkingSpot*)spot forUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
#warning They updated this in the server Nick.  Can you take a look here?
    NSDictionary* parameters = @{@"user_id": [user _id],
                                 @"spot_id": [spot _id]
                                 };
    
    [self.networkManager call:@"post" one:@"purchase" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"do something in purchaseSpot");
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

#pragma mark - Directions

- (void) openDirectionsInMapsToLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude {
    
    // Create a region centered on the starting point with a 10km span
    CLLocation* currentLocation = [[[CLLocationManager alloc] init] location];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 10000, 10000);
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObject:location]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
}



#pragma mark - Pseudo-properties

- (DTUser*) currentUser {
    return [self.dataManager currentUser];
}

- (DTUser*) defaultUser {
    return [self.dataManager defaultUser];
}

- (NSString*) defaultEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}
- (NSString*) defaultPassword {
    return [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"password"];
}
- (BOOL) defaultsExist {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:@"email"] != nil);
}

- (void) setDefaultEmail:(NSString*)email {
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Sorting

- (NSArray*) sortLotsByRating:(NSArray*)array isAscending:(BOOL)isAscending {
    [[array mutableCopy] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DTParkingLot* lotA = obj1;
        DTParkingLot* lotB = obj2;
        CGFloat ratingA = [lotA.averageRating floatValue];
        CGFloat ratingB = [lotB.averageRating floatValue];
        
        if (ratingA > ratingB) {
            return isAscending ? NSOrderedAscending : NSOrderedDescending;
        } else if (ratingA < ratingB) {
            return isAscending ? NSOrderedDescending : NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return array;
}
- (NSArray*) sortLots:(NSMutableArray*)array byDistanceFromLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude isAscending:(BOOL)isAscending {
    NSLog(@"asc/desc may not work correctly");
    [[array mutableCopy] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DTParkingLot* lotA = obj1;
        CGFloat latA = [lotA.lat floatValue];
        CGFloat lonA = [lotA.lon floatValue];
        
        CGFloat distanceA = sqrt((latitude - latA)*(latitude - latA) + (longitude - lonA)*(longitude - lonA));
        
        DTParkingLot* lotB = obj2;
        CGFloat latB = [lotB.lat floatValue];
        CGFloat lonB = [lotB.lon floatValue];
        
        CGFloat distanceB = sqrt((latitude - latB)*(latitude - latB) + (longitude - lonB)*(longitude - lonB));

        if(distanceA > distanceB) {
            return NSOrderedAscending;
        } else if (distanceA < distanceB) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    return array;
}
- (NSArray*) sortLotsByPrice:(NSMutableArray*)array isAscending:(BOOL)isAscending {
    NSLog(@"asc/desc may not work correctly");
    [[array mutableCopy] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DTParkingLot* lotA = obj1;
        DTParkingLot* lotB = obj2;
        
        CGFloat priceA = [lotA.minimumPrice floatValue];
        CGFloat priceB = [lotB.minimumPrice floatValue];
        
        if (priceA > priceB) {
            return isAscending ? NSOrderedAscending : NSOrderedDescending;
        } else if (priceA < priceB) {
            return isAscending ? NSOrderedDescending : NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return array;
}
#pragma mark - Helper Methods

- (NSArray*) parseJSON:(id)json toArrayOfClass:(__unsafe_unretained Class)theClass {
    NSArray* array = json;
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    for (NSDictionary* item in array) {
        id newItem = [[theClass alloc] init];
        [newItem setValuesForKeysWithDictionary:item];
        [newArray insertObject:newItem atIndex:[newArray count]];
    }
    return [newArray copy];
}

-(NSDate*)setDateFromString:(NSString *)date
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterFullStyle];
  return [formatter dateFromString:date];
}

#pragma mark - Data Management Methods

-(void)removeCachedLots
{
  [[DTCache sharedInstance] removeAllLots];
}

-(void)removeCachedSpots
{
  [[DTCache sharedInstance] removeAllSpots];
}

-(void)scrubTheCache
{
  [[DTCache sharedInstance] removeAll];
}

@end