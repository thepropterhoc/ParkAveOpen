//
//  DTCache.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 3/22/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTCache.h"


@interface DTCache ()

@property NSCache *lotsCache;
@property NSCache *spotsCache;
@property NSCache *reviewsCache;

@end

@implementation DTCache

+ (instancetype)sharedInstance
{
  static DTCache *sharedInstance = nil;
  static dispatch_once_t onceToken = 0;
  
  dispatch_once(&onceToken, ^{
    sharedInstance = [[[self class] alloc] init];
    sharedInstance.lotsCache = [[NSCache alloc] init];
    sharedInstance.spotsCache = [[NSCache alloc] init];
    sharedInstance.reviewsCache = [[NSCache alloc] init];
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
  return [self.spotsCache objectForKey:theLot];
}

-(NSArray*)allLots
{
  return [self.lotsCache objectForKey:@"ALL"];
}

-(NSArray*)reviewsForUser:(DTUser*)theUser
{
  return [self.reviewsCache objectForKey:theUser];
}


#pragma mark - Removal methods

-(void)removeSpotsForLot:(DTParkingLot *)theLot
{
  [self.spotsCache removeObjectForKey:theLot];
}

-(void)removeLot:(DTParkingLot *)theLot
{
  [self removeSpotsForLot:theLot];
  [self.lotsCache removeObjectForKey:theLot];
}

-(void)removeReviewsForUser:(DTUser *)theUser
{
  [self.reviewsCache removeObjectForKey:theUser];
}

-(void)removeAll
{
  [self.reviewsCache removeAllObjects];
  [self.lotsCache removeAllObjects];
  [self.spotsCache removeAllObjects];
  NSLog(@"Scrubbed the caches");
}

@end
