//
//  DTModel.h
//  Parkly
//
//  Created by CCEW on 2/24/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DTDataManager.h"
#import "DTNetworkManager.h"
#import "DTUser.h"
#import "DTParkingLot.h"
#import "DTParkingSpot.h"
#import "DTReview.h"
#import "DTCar.h"
#import "DTCache.h"
#import "DTSpotManager.h"
#import "DTLotManager.h"
#import "DTUserManager.h"
#import "DTCarManager.h"
#import "DTReviewManager.h"
#import "PDKeychainBindings.h"

@interface DTModel : NSObject

#pragma mark - Global managers

@property (weak, nonatomic) DTDataManager* dataManager;
@property (weak, nonatomic) DTNetworkManager* networkManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) DTSpotManager *spotManager;
@property (strong, nonatomic) DTLotManager *lotManager;
@property (strong, nonatomic) DTUserManager *userManager;
@property (strong, nonatomic) DTCarManager *carManager;
@property (strong, nonatomic) DTReviewManager *reviewManager;

+ (instancetype) sharedInstance;

#pragma mark - Local User Session
- (void) logoutUser;
- (BOOL) userIsLoggedIn;
- (BOOL) userHasAccount;

//most of these are not yet implemented

#pragma mark - Users

- (void) authenticateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* aUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) authenticateUserWithEmail:(NSString*)email andPassword:(NSString*)password success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getAllUsers: (void (^)(NSURLSessionDataTask *task, NSArray* allUsers))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getUserWithId:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) createUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* newUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) updateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) deleteUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getUsernameForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getUsernameForUserID:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - Lots

- (void) getAllLots: (void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) createLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) updateLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) deleteLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void) imageForLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getLotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getLotsAndSpotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void) getLotsandSpotsForCurrentLocationWithDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) decrementSpotsForLot:(DTParkingLot*)lot success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - Spots

- (void) getSpotsForLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, NSArray* spots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getLotForSpot:(DTParkingSpot*)spot success:(void(^)(NSURLSessionDataTask *task, DTParkingLot* responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) createSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) updateSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) deleteSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - Cars

- (void) getCarsForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSArray* cars))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, DTCar* aCar))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) createCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) updateCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) deleteCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - Reviews

- (void) getAllReviews: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getReviewsForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSArray* reviews))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) createReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) updateReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) deleteReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - Purchase

//- (void) purchaseSpot:(DTParkingSpot*)spot forUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMessage))failure;

- (void) purchaseSpot:(DTParkingSpot*)spot forUser:(DTUser*)user withCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;


//- (void) makePaymentFromUser:(DTUser*)user  forSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, DTUser* aUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//sandbox method
- (void) addCreditCard: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

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
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMessage))failure;

#pragma mark - My Spots

- (void) reserveSpot:(DTParkingSpot*)spot;
-(NSArray*) allReservedSpots;

#pragma mark - Directions

- (void) openDirectionsInMapsToLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;
- (CLLocation*) currentUserLocation;
- (void) stopUpdatingLocation;
- (void) startUpdatingLocation;

#pragma mark - Pseudo-properties

- (DTUser*) currentUser;
- (DTUser*) defaultUser;
- (DTCar*) defaultCar;
- (void) setDefaultCar:(DTCar*)car;
- (void) setCurrentUser:(DTUser*)user;

- (NSArray*) currentUserCars;
- (void) addCurrentUserCar:(DTCar*)car;

- (BOOL) defaultsExist;

- (void) setDefaultUser:(DTUser*)user;

#pragma mark - Helper Methods

- (id) parseJSON:(id)json toArrayOfClass:(__unsafe_unretained Class)theClass;
- (NSString*) formattedDateFromString:(NSString*)date;

#pragma mark - Data Management Methods

-(void)scrubTheCache;
-(void)removeCachedLots;
-(void)removeCachedSpots;
-(void)removeCachedCars;


@end
