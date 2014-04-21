//
//  DTCache.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 3/22/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTParkingLot.h"
#import "DTParkingSpot.h"
#import "DTUser.h"
#import "DTReview.h"
#import "DTCar.h"


@interface DTCache : NSObject

#pragma mark - Global instance

+ (instancetype)sharedInstance;

#pragma mark - Checking methods

-(BOOL)hasImageForLot:(DTParkingLot*)theLot;
-(BOOL)hasSpotsForLot:(DTParkingLot*)theLot;
-(BOOL)hasLot:(DTParkingLot*)theLot;
-(BOOL)hasReviewsForUser:(DTUser*)theUser;
-(BOOL)hasCarsForUser:(DTUser*)theUser;
-(BOOL)hasLots;

#pragma mark - Adding methods

-(void)addImage:(UIImage*)image forLot:(DTParkingLot*)theLot;
-(void)addLots:(NSArray*)theLots;
-(void)addSpots:(NSArray*)theSpots forLot:(DTParkingLot*)theLot;
-(void)addReviews:(NSArray*)theReviews forUser:(DTUser*)theUser;
-(void)addCars:(NSArray*)theCars forUser:(DTUser*)theUser;

#pragma mark - Fetching methods

-(UIImage*)imageForLot:(DTParkingLot*)theLot;
-(NSArray*)spotsForLot:(DTParkingLot*)theLot;
-(NSArray*)allLots;
-(NSArray*)reviewsForUser:(DTUser*)theUser;
-(NSArray*)carsForUser:(DTUser*)theUser;

#pragma mark - Removal methods

-(void)removeImageForLot:(DTParkingLot*)theLot;
-(void)removeSpotsForLot:(DTParkingLot *)theLot;
-(void)removeLot:(DTParkingLot *)theLot;
-(void)removeReviewsForUser:(DTUser *)theUser;
-(void)removeCarsForUser:(DTUser*)theUser;
-(void)removeAllImages;
-(void)removeAllLots;
-(void)removeAllSpots;
-(void)removeAllCars;

-(void)removeAll;

@end