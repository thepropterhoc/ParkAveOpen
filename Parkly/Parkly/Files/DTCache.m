//
//  DTCache.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 3/22/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTCache.h"


@interface DTCache ()

@property NSCache *theCache;

@end

@implementation DTCache

+ (instancetype)sharedInstance
{
  static DTCache *sharedInstance = nil;
  static dispatch_once_t onceToken = 0;
  
  dispatch_once(&onceToken, ^{
    sharedInstance = [[[self class] alloc] init];
    sharedInstance.theCache = [[NSCache alloc] init];
  });
  
  return sharedInstance;
}


#pragma mark - Checking methods

-(BOOL)hasSpotsForLot:(DTParkingLot*)theLot
{
#warning Bad implementation
  return YES;
}

-(BOOL)hasLot:(DTParkingLot*)theLot
{
#warning Bad implementation
  return YES;
}

-(BOOL)hasReviewsForUser:(DTUser*)theUser
{
#warning Bad implementation
  return YES;
}


#pragma mark - Adding methods

-(void)addSpot:(DTParkingSpot*)theSpot forLot:(DTParkingLot*)theLot
{
  
}

-(void)addLot:(DTParkingLot*)theLot
{
  
}

-(void)addReview:(DTReview*)theReview forUser:(DTUser*)theUser
{
  
}

-(void)addSpots:(NSArray*)theSpots forLot:(DTParkingLot*)theLot
{
  
}

-(void)addReviews:(NSArray*)theReviews forUser:(DTUser*)theUser
{
  
}


#pragma mark - Updating methods

-(void)updateSpot:(DTParkingSpot*)theSpot forLot:(DTParkingLot*)theLot
{
  
}

-(void)updateLot:(DTParkingLot*)theLot
{
  
}

-(void)updateReview:(DTReview*)theReview forUser:(DTUser*)theUser
{
  
}

-(void)updateSpots:(NSArray*)theSpots forLot:(DTParkingLot*)theLot
{
  
}

-(void)updateReviews:(NSArray*)theReviews forUser:(DTUser*)theUser
{
  
}


#pragma mark - Fetching methods

-(NSArray*)spotsForLot:(DTParkingLot*)theLot
{
  return [self.theCache objectForKey:theLot];
}

-(NSArray*)allLots
{
  return [self.theCache objectForKey:@"allLots"];
}

-(NSArray*)reviewsForUser:(DTUser*)theUser
{
  return [self.theCache objectForKey:theUser];
}


#pragma mark - Removal methods

-(void)removeSpotsForLot:(DTParkingLot *)theLot
{
  [self.theCache removeObjectForKey:theLot];
}

-(void)removeLot:(DTParkingLot *)theLot
{
  [self removeSpotsForLot:theLot];
  [self.theCache removeObjectForKey:theLot];
}

-(void)removeReviewsForUser:(DTUser *)theUser
{
  [self.theCache removeObjectForKey:theUser];
}

@end
