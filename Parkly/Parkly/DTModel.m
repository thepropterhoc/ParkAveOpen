//
//  DTModel.m
//  Parkly
//
//  Created by CCEW on 2/24/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTModel.h"

@interface DTModel ()

- (id) parseJSON:(id)json toArrayOfClass:(__unsafe_unretained Class)theClass;

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
    sharedInstance.spotManager = [[DTSpotManager alloc] init];
    sharedInstance.lotManager = [[DTLotManager alloc] init];
    sharedInstance.userManager = [[DTUserManager alloc] init];
    sharedInstance.carManager = [[DTCarManager alloc] init];
    sharedInstance.dateFormatter = [[NSDateFormatter alloc] init];
    [sharedInstance.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    sharedInstance.shortDateFormatter = [[NSDateFormatter alloc] init];
    [sharedInstance.shortDateFormatter setDateFormat:@"MM'/'dd'/'YY HH:mm"];
    NSLocale *englishLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [sharedInstance.dateFormatter setLocale:englishLocale];
    [sharedInstance.shortDateFormatter setLocale:englishLocale];
    
    [sharedInstance.locationManager startUpdatingLocation];
  });
  return sharedInstance;
}

#pragma mark - Local User Session

- (void) logoutUserWithSuccess: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSDictionary* parameters = @{@"email": [[self.dataManager currentUser] email],
                               @"password":@"logout"
                               };
  [self.networkManager call:@"post" payload:@[@"users", @"session"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    if(success){
      success(task, responseObject);
    }
    [self.dataManager setCurrentUser:nil];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if(failure){
      failure(task, error);
    }
  }];
}

- (BOOL) userIsLoggedIn {
  return self.dataManager.currentUser != nil;
}
- (BOOL) userHasAccount {
  return [self defaultsExist];
}

#pragma mark - Users

- (void) authenticateUserWithEmail:(NSString*)email andPassword:(NSString*)password success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager authenticateUserWithEmail:email andPassword:password success:success failure:failure];
}

- (void) authenticateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* aUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager authenticateUser:user success:success failure:failure];
}

- (void) getAllUsers: (void (^)(NSURLSessionDataTask *task, NSArray* allUsers))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager getAllUsers:success failure:failure];
}

- (void) getUserWithId:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager getUserWithId:userID success:success failure:failure];
}

- (void) createUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* newUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager createUser:user success:success failure:failure];
}

- (void) updateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager updateUser:user success:success failure:failure];
}

- (void) deleteUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager deleteUser:user success:success failure:failure];
}

- (void) getUsernameForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager getUsernameForUser:user success:success failure:failure];
}

- (void) getUsernameForUserID:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.userManager getUsernameForUserID:userID success:success failure:failure];
}

#pragma mark - Lots

- (void) getAllLots: (void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager getAllLots:success failure:failure];
}

- (void) getLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager getLot:lot success:success failure:failure];
}

- (void) createLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager createLot:lot success:success failure:failure];
}

- (void) updateLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager updateLot:lot success:success failure:failure];
}

- (void) deleteLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager deleteLot:lot success:success failure:failure];
}

-(void) imageForLot:(DTParkingLot *)lot success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
  [self.lotManager imageForLot:lot success:success failure:failure];
}

- (void) getLotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager getLotsNearLatitude:latitude andLongitude:longitude withDistance:distance success:success failure:failure];
}

- (void) getLotsAndSpotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager getLotsAndSpotsNearLatitude:latitude andLongitude:longitude withDistance:distance success:success failure:failure];
}

-(void)getLotsandSpotsForCurrentLocationWithDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
  [self.lotManager getLotsandSpotsForCurrentLocationWithDistance:distance success:success failure:failure];
}

- (void) decrementSpotsForLot:(DTParkingLot*)lot success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.lotManager decrementSpotsForLot:lot success:success failure:failure];
}

#pragma mark - Spots

- (void) getSpotsForLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, NSArray* spots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.spotManager getSpotsForLot:lot success:success failure:failure];
}

- (void) getSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.spotManager getSpot:spot success:success failure:failure];
}

- (void) getLotForSpot:(DTParkingSpot*)spot success:(void (^)(NSURLSessionDataTask *task, DTParkingLot *responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [self.spotManager getLotForSpot:spot success:success failure:failure];
}

- (void) createSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.spotManager createSpot:spot success:success failure:failure];
}

- (void) updateSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.spotManager updateSpot:spot success:success failure:failure];
}

- (void) deleteSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.spotManager deleteSpot:spot success:success failure:failure];
}

#pragma mark - Cars

- (void) getCarsForUser:(DTUser *)user success:(void (^)(NSURLSessionDataTask *task, NSArray* cars))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
  [self.carManager getCarsForUser:user success:success failure:failure];
}

- (void) getCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, DTCar* aCar))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.carManager getCar:car success:success failure:failure];
}

- (void) createCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.carManager createCar:car success:success failure:failure];
}

- (void) updateCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.carManager updateCar:car success:success failure:failure];
}

- (void) deleteCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.carManager deleteCar:car success:success failure:failure];
}

- (NSArray*) currentUserCars {
  return [[DTCache sharedInstance] carsForUser:[self currentUser]];
}

- (void) addCurrentUserCar:(DTCar*)car {
  [[DTCache sharedInstance] addCars:[NSArray arrayWithObject:car] forUser:[self currentUser]];
}

#pragma mark - Reviews

- (void) getAllReviews: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.reviewManager getAllReviews:success failure:failure];
}

- (void) getReviewsForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSArray* reviews))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.reviewManager getReviewsForUser:user success:success failure:failure];
}

- (void) getReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.reviewManager getReview:review success:success failure:failure];
}

- (void) createReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.reviewManager createReview:review success:success failure:failure];
}

- (void) updateReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.reviewManager updateReview:review success:success failure:failure];
}

- (void) deleteReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self.reviewManager deleteReview:review success:success failure:failure];
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
  
  [self.networkManager call:@"post" payload:@[@"addpaymentmethod"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
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
  
  [self.networkManager call:@"post" payload:@[@"addpaymentmethod"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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


- (void) purchaseSpot:(DTParkingSpot*)spot forUser:(DTUser*)user withCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  
  NSDictionary* parameters = @{@"user_id": [user _id],
                               @"spot_id": [spot _id]/*,
                               @"car_id": [car _id]*/
                               };
    
  [self.networkManager call:@"post" payload:@[@"purchase"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
      
      [self reserveSpot:spot];
      
      success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      failure(task, error);
    }
   ];
}
   
#pragma mark - My Spots
   
- (void) reserveSpot:(DTParkingSpot*)spot {
 [[[self.currentUser reservedSpots] mutableCopy] insertObject:spot atIndex:0];
}

- (NSArray*) allReservedSpots {
  if([[DTModel sharedInstance] currentUser]){
   [self.networkManager call:@"get" payload:@[@"users", [[self currentUser] _id]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
     
     id retval = [self parseJSON:responseObject toArrayOfClass:[DTUser class]];
     
     DTUser *newUser;
     if ([retval isKindOfClass:[NSArray class]]){
       newUser = retval[0];
     } else {
       newUser = retval;
     }
     
     self.currentUser.reservedSpots = [newUser reservedSpots];
     
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
     NSLog(@"error! : %@", error);
   }];
   return [[self currentUser] reservedSpots];
  } else {
    return @[];
  }
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

-(void) startUpdatingLocation
{
  [self.locationManager startUpdatingLocation];
}

-(void) stopUpdatingLocation
{
  [self.locationManager stopUpdatingLocation];
  [self.locationManager stopMonitoringSignificantLocationChanges];
  NSLog(@"Stopped updating location");
}

   
#pragma mark - Pseudo-properties
   
 - (DTUser*) currentUser
{
  return [self.dataManager currentUser];
}
 
 - (DTUser*) defaultUser
{
 return [self.dataManager defaultUser];
}

- (DTCar*) defaultCar {
 return [self.dataManager defaultCar];
}

- (void) setDefaultCar:(DTCar *)car
{
 [self.dataManager setDefaultCar:car];
}
 
 - (NSString*) defaultEmail
{
 return [self.dataManager defaultUser].email;
}

 - (NSString*) defaultPassword
{
 return [self.dataManager defaultUser].password;
}

 - (BOOL) defaultsExist
{
 return [self.dataManager defaultUser] != nil;
}

- (void) setDefaultUser:(DTUser *)user
{
  [self.dataManager setDefaultUser:user];
}

- (void) setCurrentUser:(DTUser *)user
{
  [self.dataManager setCurrentUser:user];
}

#pragma mark - Helper Methods

- (id) parseJSON:(id)json toArrayOfClass:(__unsafe_unretained Class)theClass
{
  
  if([json isKindOfClass:[NSDictionary class]]){
    
    NSMutableArray *tempKeys = [[(NSDictionary *) json allKeys] mutableCopy];

    id testObject = [[theClass alloc] init];
    for (NSString* key in tempKeys) {
      if (![testObject respondsToSelector:NSSelectorFromString(key)]) {
        [tempKeys removeObject:key];
        NSLog(@"key %@ was not used while parsing json.", key);
      }
    }
    
    NSArray* keys = [tempKeys copy];
    
    id newItem = [[theClass alloc] init];
      
      //assign properties
    for (NSString* key in keys) {
      id value = [json valueForKey:key];
      [newItem setValue:value forKey:key];
    }
    
    return newItem;
  } else {
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
}

- (NSString*)stringFromDate:(NSDate *)date
{
  return [self.dateFormatter stringFromDate:date];
}

- (NSDate*) dateFromString:(NSString *)string
{
  NSDate *output = [self.dateFormatter dateFromString:string];
  
  NSLog(@"String input : '%@' resulted in date : %@", string, output);
  return output;
}

- (NSString*) shortStringFromDate:(NSDate *)date
{
  NSString *shortDate = [self.shortDateFormatter stringFromDate:date];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
  if ([components hour] > 12){
    shortDate = [shortDate stringByAppendingString:@" PM"];
  } else {
    shortDate = [shortDate stringByAppendingString:@" AM"];
  }
  return shortDate;
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
 
- (void)removeCachedCars
{
  [[DTCache sharedInstance] removeAllCars];
}
 
- (void)scrubTheCache
{
  [[DTCache sharedInstance] removeAll];
}
   
@end