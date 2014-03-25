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

#warning This object is not functional yet.  DO NOT USE IT.
@interface DTCache : NSObject

#pragma mark - Global instance

+ (instancetype)sharedInstance;

#pragma mark - Checking methods

-(BOOL)hasSpotsForLot:(DTParkingLot*)theLot;
-(BOOL)hasLot:(DTParkingLot*)theLot;
-(BOOL)hasReviewsForUser:(DTUser*)theUser;

#pragma mark - Adding methods

-(void)addSpot:(DTParkingSpot*)theSpot forLot:(DTParkingLot*)theLot;
-(void)addLot:(DTParkingLot*)theLot;
-(void)addReview:(DTReview*)theReview forUser:(DTUser*)theUser;

-(void)addSpots:(NSArray*)theSpots forLot:(DTParkingLot*)theLot;
-(void)addReviews:(NSArray*)theReviews forUser:(DTUser*)theUser;

#pragma mark - Updating methods

-(void)updateSpot:(DTParkingSpot*)theSpot forLot:(DTParkingLot*)theLot;
-(void)updateLot:(DTParkingLot*)theLot;
-(void)updateReview:(DTReview*)theReview forUser:(DTUser*)theUser;

-(void)updateSpots:(NSArray*)theSpots forLot:(DTParkingLot*)theLot;
-(void)updateReviews:(NSArray*)theReviews forUser:(DTUser*)theUser;

#pragma mark - Fetching methods

-(NSArray*)spotsForLot:(DTParkingLot*)theLot;
-(NSArray*)allLots;
-(NSArray*)reviewsForUser:(DTUser*)theUser;

#pragma mark - Removal methods

-(void)removeSpotsForLot:(DTParkingLot *)theLot;
-(void)removeLot:(DTParkingLot *)theLot;
-(void)removeReviewsForUser:(DTUser *)theUser;

-(void)removeAll;

@end