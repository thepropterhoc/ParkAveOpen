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
@property (strong, nonatomic) CLLocationManager *locationManager;

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
    sharedInstance.locationManager = [[CLLocationManager alloc] init];
    [sharedInstance.locationManager setPausesLocationUpdatesAutomatically:YES];
    [sharedInstance.locationManager startMonitoringSignificantLocationChanges];
  });
  return sharedInstance;
}

#pragma mark - Local User Session
- (void) logoutUser {
  NSDictionary* parameters = @{@"email": [[self.dataManager currentUser] email],
                               @"password":@"logout"
                               };
  [self.networkManager call:@"post" one:@"users" two:@"session" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"You done logged out there!");
    [self.dataManager logoutUser];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"error logging out. %@", error);
  }];
}

- (BOOL) userIsLoggedIn {
  return [self.dataManager isUserLoggedIn];
}
- (BOOL) userHasAccount {
  return [self defaultsExist];
}

#pragma mark - Paypal



#pragma mark - Users

- (void) authenticateUserWithEmail:(NSString*)email andPassword:(NSString*)password success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  NSDictionary* parameters = @{@"email": email,
                               @"password": password};
  
  //NSLog(@"%@",parameters);
  
  [self.networkManager call:@"post" one:@"users" two:@"session" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
    [self.networkManager checkResponseStatus:responseObject success:^(id responseObject) {
      
      [[[self dataManager] currentUser] setValuesForKeysWithDictionary:responseObject];
      //set the defaults for next time if they aren't the same
      [self setDefaultEmail:email];
      [[PDKeychainBindings sharedKeychainBindings] setString:password forKey:@"password"];
      
    } failure:^(NSString *statusCode, NSString *description) {
      NSLog(@"There was an error. status code %@", statusCode);
    }];
    
    /*if([[responseObject valueForKey:@"err"] isEqualToString:@"nomatch"]) {
     responseObject = @"error";
     } else {
     [[[self dataManager] currentUser] setValuesForKeysWithDictionary:responseObject];
     NSLog(@"!!!!!~~~~~~~~~~~~~~~~~~~%@", [[[self dataManager] currentUser] _id]);
     //set the defaults for next time if they aren't the same
     [self setDefaultEmail:email];
     [[PDKeychainBindings sharedKeychainBindings] setString:password forKey:@"password"];
     NSLog(@"default email: %@. You're logged in.", [self defaultEmail]);
     }*/
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

- (NSString*) getUsernameForUser:(DTUser*)user {
  return [self getUsernameForUserID:[user _id]];
}

- (NSString*) getUsernameForUserID:(NSString*)userID {
  return @"REMOVE THIS!!!!! THIS NEEDS TO CHANGE TO THE NEW VERSION!";
}

- (void) getUsernameForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self getUsernameForUserID:[user _id] success:^(NSURLSessionDataTask *task, NSString *name) {
    success(task, name);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getUsernameForUserID:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.networkManager call:@"get" one:@"username" two:userID parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSString* name = [NSString stringWithFormat:@"%@ %@",[responseObject valueForKey:@"firstName"], [responseObject valueForKey:@"lastName"]];
    success(task, name);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"error!:%@",error);
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

-(void) imageForLot:(DTParkingLot *)lot success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
  if([[DTCache sharedInstance] hasImageForLot:lot]){
    success(nil, [[DTCache sharedInstance] imageForLot:lot]);
    return;
  } else {
    NSLog(@"Cache miss for image");
  }
  UIImage *theImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/streetview?size=320x220&location=%.3f,%.3f&fov=90&heading=235&pitch=10&sensor=false", lot.lat.floatValue, lot.lon.floatValue]]]];
  if(theImage){
    [[DTCache sharedInstance] addImage:theImage forLot:lot];
    success(nil, theImage);
  } else {
    failure(nil, [[NSError alloc] initWithDomain:@"Network failure" code:404 userInfo:nil]);
  }
}

- (void) getLotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  NSString* string = [NSString stringWithFormat:@"%f+%f+%f", latitude, longitude, distance];
  
  [self.networkManager call:@"get" one:@"location" two:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray* lotArray = [self parseJSON:responseObject toArrayOfClass:[DTParkingLot class]];
    [[DTCache sharedInstance] addLots:lotArray];
    success(task, lotArray);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getLotsAndSpotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  NSString* string = [NSString stringWithFormat:@"%f+%f+%f", latitude, longitude, distance];
  
  [self.networkManager call:@"get" one:@"location" two:@"all" three:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
    
    //parse lots and spots arrays separately
    NSArray* lotArray = [self parseJSON:[responseObject objectForKey:@"lots"] toArrayOfClass:[DTParkingLot class]];
    NSArray* spotArray = [self parseJSON:[responseObject objectForKey:@"spots"] toArrayOfClass:[DTParkingSpot class]];
    
    //add lots to cache
    [[DTCache sharedInstance] addLots:lotArray];
    //loop through lots
    for (DTParkingLot* lot in lotArray) {
      //for each, create an array of spots that belong to it
      NSMutableArray* currentSpots = [[NSMutableArray alloc] init];
      NSString* lot_id = [lot _id];
      [self imageForLot:lot success:^(NSURLSessionDataTask *task, id responseObject) {
        
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
      }];
      [self getUserWithId:lot.user_id success:^(NSURLSessionDataTask *task, DTUser *user) {
        [self getReviewsForUser:user success:^(NSURLSessionDataTask *task, NSArray *reviews) {
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
          
        }];
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
      }];
      //now loop through spots
      for (DTParkingSpot* spot in spotArray) {
        //for each spot, if its lot id matches the current lot's id, add the spot to currentSpots
        if ([[spot lot_id] isEqualToString:lot_id]) {
          [currentSpots insertObject:spot atIndex:0];
        }
      }
      
      //remove currentSpots from spot array
      [[spotArray mutableCopy] removeObjectsInArray:[currentSpots copy]];
      
      //add currentSpots to the cache
      [[DTCache sharedInstance] addSpots:currentSpots forLot:lot];
    }
    
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

-(void)getLotsandSpotsForCurrentLocationWithDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
  [self getLotsAndSpotsNearLatitude:self.locationManager.location.coordinate.latitude andLongitude:self.locationManager.location.coordinate.longitude withDistance:distance success:success failure:failure];
}


- (void) decrementSpotsForLot:(DTParkingLot*)lot success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.networkManager call:@"put" one:@"lots" two:[lot _id] parameters:[lot dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
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
  } else {
    NSLog(@"Cache miss");
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


- (void) getLotForSpot:(DTParkingSpot*)spot success:(void (^)(NSURLSessionDataTask *task, DTParkingLot *responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self getAllLots:^(NSURLSessionDataTask *task, NSArray *allLots) {
    for(DTParkingLot *lot in allLots){
      [self getSpotsForLot:lot success:^(NSURLSessionDataTask *task, NSArray *spots) {
        for(DTParkingSpot *theSpot in spots){
          if(theSpot == spot){
            success(task, lot);
            return;
          }
        }
        failure(task, nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
      }];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
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

- (void) getCarsForUser:(DTUser *)user success:(void (^)(NSURLSessionDataTask *task, NSArray* cars))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
  
  if ([[DTCache sharedInstance] hasCarsForUser:user]) {
    success([[NSURLSessionDataTask alloc] init], [[DTCache sharedInstance] carsForUser:user]);
  } else {
    
    [self.networkManager call:@"get" one:@"users" two:[user _id] three:@"cars" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      NSArray* cars = [self parseJSON:responseObject toArrayOfClass:[DTCar class]];
      
      if(cars) {
        [[DTCache sharedInstance] addCars:cars forUser:user];
      } else {
        NSLog(@"No cars for user, so it's not stored in the cache");
      }
      
      success(task, cars);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      failure(task, error);
    }];
  }
}

- (void) getCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, DTCar* aCar))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.networkManager call:@"get" one:@"users" two:[car user_id] three:@"cars" four:[car _id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    DTCar* newCar = [[DTCar alloc] init];
    [newCar setValuesForKeysWithDictionary:responseObject];
    success(task, newCar);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) createCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.networkManager call:@"post" one:@"users" two:[car user_id] three:@"cars" parameters:[car dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    
    //add car to cache
    [[DTCache sharedInstance] addCars:[NSArray arrayWithObject:car] forUser:[self currentUser]];
    
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

- (NSArray*) currentUserCars {
  return [[DTCache sharedInstance] carsForUser:[self currentUser]];
}

- (void) addCurrentUserCar:(DTCar*)car {
  [[DTCache sharedInstance] addCars:[NSArray arrayWithObject:car] forUser:[self currentUser]];
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
  
  if([[DTCache sharedInstance] hasReviewsForUser:user]){
    success(nil, [[DTCache sharedInstance] reviewsForUser:user]);
    return;
  }
  
  NSLog(@"%@", user._id);
  [self.networkManager call:@"get" one:@"users" two:[user _id] three:@"reviews" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *reviews = [self parseJSON:responseObject toArrayOfClass:[DTReview class]];
    [[DTCache sharedInstance] addReviews:reviews forUser:user];
    success(task, reviews);
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

- (void) addCreditCardOfType:(NSString*)type
                      number:(NSString*)number
                 expireMonth:(NSString*)expireMonth
                  expireYear:(NSString*)expireYear
                        cvv2:(NSString*)cvv2
       billingAddressLineOne:(NSString*)line1
                        city:(NSString*)city
                       state:(NSString*)state
                  postalCode:(NSString*)postalCode
                 countryCode:(NSString*)countryCode
                     success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMessage))failure {
  
  NSDictionary* parameters = @{
                               @"type": type,
                               @"number": number,
                               @"expire_month": expireMonth,
                               @"expire_year": expireYear,
                               @"cvv2": cvv2,
                               @"first_name": [[self.dataManager currentUser] firstName],
                               @"last_name": [[self.dataManager currentUser] lastName],
                               @"billing_address": @{
                                   @"line1": line1,
                                   @"city": city,
                                   @"state": state,
                                   @"postal_code": postalCode,
                                   @"country_code": countryCode
                                   },
                               @"payer_id": [[self.dataManager currentUser] _id]
                               };
  
  [self.networkManager call:@"post" one:@"addpaymentmethod" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
    if([[responseObject valueForKeyPath:@"status"] intValue] == 200) {
      success(task, responseObject);
    } else {
      failure(task, @"There was an error adding the card.");
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, [NSString stringWithFormat:@"%@", error]);
  }];
}

- (void) addCreditCard: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure {
  NSDictionary* parameters = @{
                               @"type": @"visa",
                               @"number": @"4417119669820331",
                               @"expire_month": @"11",
                               @"expire_year": @"2018",
                               @"cvv2": @"874",
                               @"first_name": @"Joe",
                               @"last_name": @"Shopper",
                               @"billing_address": @{
                                   @"line1": @"52 N Main ST",
                                   @"city": @"Johnstown",
                                   @"state": @"OH",
                                   @"postal_code": @"43210",
                                   @"country_code": @"US"
                                   },
                               @"payer_id": [[self.dataManager currentUser] _id]
                               };
  
  [self.networkManager call:@"post" one:@"addpaymentmethod" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    //NSLog(@"response: %@", responseObject);
    
    [self.networkManager checkResponseStatus:responseObject success:^(id responseObject) {
      success(task, responseObject);
    } failure:^(NSString *statusCode, NSString *description) {
      NSLog(@"Error Status %@ - %@", statusCode, description);
    }];
    
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}


- (void) purchaseSpot:(DTParkingSpot*)spot forUser:(DTUser*)user withCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  NSDictionary* parameters = @{@"user_id": [user _id],
                               @"spot_id": [spot _id]/*,
                               @"car_id": [car _id]*/
                               };
    
    [self.networkManager call:@"post" one:@"purchase" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
      
      [self reserveSpot:spot];
      
      success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      failure(task, error);
    }
     ];
  }
   
  /*- (void) makePaymentFromUser:(DTUser*)user forSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, DTUser* aUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
   
   NSDictionary* parameters = @{
   @"spot_id": [spot _id],
   @"user_id": [user _id],
   @"type": @"visa",
   @"number": @"4417119669820331",
   @"expire_month": @"11",
   @"expire_year": @"2018",
   @"cvv2": @"874",
   @"first_name": [user firstName],
   @"last_name": [user lastName],
   @"billing_address": @{
   @"line1": @"52 N Main ST",
   @"city": @"Johnstown",
   @"state": @"OH",
   @"postal_code": @"43210",
   @"country_code": @"US"
   }
   };
   
   [self.networkManager call:@"post" one:@"purchase" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
   #warning something needs to happen here
   success(task, responseObject);
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
   failure(task, error);
   }];
   }*/
   
   
#pragma mark - My Spots
   
   - (void) reserveSpot:(DTParkingSpot*)spot {
     [[[self.currentUser reservedSpots] mutableCopy] insertObject:spot atIndex:0];
   }
   
   - (NSArray*) allReservedSpots {
     [self.networkManager call:@"get" one:@"users" two:[[self currentUser] _id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
       DTUser* newUser = [self parseJSON:responseObject toArrayOfClass:[DTUser class]][0];
       self.currentUser.reservedSpots = [newUser reservedSpots];
       
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
       NSLog(@"error! : %@", error);
     }];
     return [[self currentUser] reservedSpots];
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
   
   -(CLLocation*)currentUserLocation
  {
    return [self.locationManager location];
  }
   
   
   
#pragma mark - Pseudo-properties
   
   - (DTUser*) currentUser {
     return [self.dataManager currentUser];
   }
   
   - (DTUser*) defaultUser {
     return [self.dataManager defaultUser];
   }
   - (DTCar*) defaultCar {
     return [self.dataManager defaultCar];
   }
   - (void) setDefaultCar:(DTCar *)car {
     [self.dataManager setDefaultCar:car];
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
  
  if ([array count] == 0) {
    return nil;
  }
  
  NSMutableArray* newArray = [[NSMutableArray alloc] init];
  
  //find the valid keys for this class
  NSMutableArray* tempKeys = [[array[0] allKeys] mutableCopy];
  id testObject = [[theClass alloc] init];
  for (NSString* key in tempKeys) {
    if (![testObject respondsToSelector:NSSelectorFromString(key)]) {
      [tempKeys removeObject:key];
      NSLog(@"key %@ was not used while parsing json.", key);
    }
  }
  NSArray* keys = [tempKeys copy];
  
  for (NSDictionary* item in array) {
    id newItem = [[theClass alloc] init];
    
    //assign properties
    for (NSString* key in keys) {
      id value = [item valueForKey:key];
      [newItem setValue:value forKey:key];
    }
    //insert the item into the array
    [newArray insertObject:newItem atIndex:[newArray count]];
  }
  return [newArray copy];
}

- (NSString*) formattedDateFromString:(NSString*)date {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
  
  NSDate* tempDate = [formatter dateFromString:[date substringToIndex:10]];
  [formatter setDateStyle:NSDateFormatterLongStyle];
  
  return [formatter stringFromDate:tempDate];
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
   
   -(void)removeCachedCars
  {
    [[DTCache sharedInstance] removeAllCars];
  }
   
   -(void)scrubTheCache
  {
    [[DTCache sharedInstance] removeAll];
  }
   
   @end