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


@interface DTCache : NSObject

#pragma mark - Global instance

+ (instancetype)sharedInstance;

#pragma mark - Checking methods

-(BOOL)hasSpotsForLot:(DTParkingLot*)theLot;
-(BOOL)hasLot:(DTParkingLot*)theLot;
-(BOOL)hasReviewsForUser:(DTUser*)theUser;
-(BOOL)hasLots;

#pragma mark - Adding methods

-(void)addLots:(NSArray*)theLots;
-(void)addSpots:(NSArray*)theSpots forLot:(DTParkingLot*)theLot;
-(void)addReviews:(NSArray*)theReviews forUser:(DTUser*)theUser;

#pragma mark - Fetching methods

-(NSArray*)spotsForLot:(DTParkingLot*)theLot;
-(NSArray*)allLots;
-(NSArray*)reviewsForUser:(DTUser*)theUser;

#pragma mark - Removal methods

-(void)removeSpotsForLot:(DTParkingLot *)theLot;
-(void)removeLot:(DTParkingLot *)theLot;
-(void)removeReviewsForUser:(DTUser *)theUser;
-(void)removeAllLots;
-(void)removeAllSpots;

-(void)removeAll;

@end