//
//  DTLotManager.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/31/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotManager.h"
#import "DTCache.h"
#import "DTModel.h"

@implementation DTLotManager

- (void) getAllLots: (void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  if([[DTCache sharedInstance] hasLots]){
    success(nil, [[DTCache sharedInstance] allLots]);
    return;
  } else {
    NSLog(@"Cache miss for all lots");
  }
  
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"lots"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *resultArray = [[DTModel sharedInstance] parseJSON:responseObject toArrayOfClass:[DTParkingLot class]];
    for (DTParkingLot *lot in resultArray){
      CLLocation *lotLocation = [[CLLocation alloc] initWithLatitude:lot.lat.floatValue longitude:lot.lon.floatValue];
      lot.distance = [NSNumber numberWithFloat:[[DTModel sharedInstance].locationManager.location distanceFromLocation:lotLocation]];
      [[DTModel sharedInstance] getSpotsForLot:lot success:^(NSURLSessionDataTask *task, NSArray *spots) {
        [[DTCache sharedInstance] addSpots:spots forLot:lot];
      } failure:nil];
      [[DTModel sharedInstance] imageForLot:lot success:^(NSURLSessionDataTask *task, id responseObject) {
        [[DTCache sharedInstance] addImage:responseObject forLot:lot];
      } failure:nil];
    }
    [[DTCache sharedInstance] addLots:resultArray];
    if(success){
      success(task, resultArray);
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if(failure){
      failure(task, error);
    }
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
    if(success){
      success(nil, theImage);
    }
  } else {
    failure(nil, [[NSError alloc] initWithDomain:@"Network failure" code:404 userInfo:nil]);
  }
}

- (void) getLotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, NSArray* allLots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  NSString* string = [NSString stringWithFormat:@"%f+%f+%f", latitude, longitude, distance];
  
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"location", string] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray* lotArray = [[DTModel sharedInstance] parseJSON:responseObject toArrayOfClass:[DTParkingLot class]];
    for (DTParkingLot *lot in lotArray){
      CLLocation *lotLocation = [[CLLocation alloc] initWithLatitude:lot.lat.floatValue longitude:lot.lon.floatValue];
      lot.distance = [NSNumber numberWithFloat:[[DTModel sharedInstance].locationManager.location distanceFromLocation:lotLocation]];
    }
    [[DTCache sharedInstance] addLots:lotArray];
    success(task, lotArray);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getLotsAndSpotsNearLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude withDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  NSString* string = [NSString stringWithFormat:@"%f+%f+%f", latitude, longitude, distance];
  
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"location", @"all", string] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray* lotArray = [[DTModel sharedInstance] parseJSON:[responseObject objectForKey:@"lots"] toArrayOfClass:[DTParkingLot class]];
    NSArray* spotArray = [[DTModel sharedInstance] parseJSON:[responseObject objectForKey:@"spots"] toArrayOfClass:[DTParkingSpot class]];
    
    [[DTCache sharedInstance] addLots:lotArray];
    
    for (DTParkingLot* lot in lotArray) {
      //for each, create an array of spots that belong to it
      NSMutableArray* currentSpots = [[NSMutableArray alloc] init];
      NSString* lot_id = [lot _id];
      CLLocation *lotLocation = [[CLLocation alloc] initWithLatitude:lot.lat.floatValue longitude:lot.lon.floatValue];
      lot.distance = [NSNumber numberWithFloat:[[DTModel sharedInstance].locationManager.location distanceFromLocation:lotLocation]];
      [self imageForLot:lot success:nil failure:nil];
      [[DTModel sharedInstance] getUserWithId:lot.user_id success:^(NSURLSessionDataTask *task, DTUser *user) {
        [[DTModel sharedInstance] getReviewsForUser:user success:nil failure:nil];
      } failure:nil];
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
    if(success){
      success(task, responseObject);
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

-(void)getLotsandSpotsForCurrentLocationWithDistance:(CGFloat)distance success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
  [[DTModel sharedInstance] getLotsAndSpotsNearLatitude:[DTModel sharedInstance].locationManager.location.coordinate.latitude andLongitude:[DTModel sharedInstance].locationManager.location.coordinate.longitude withDistance:distance success:success failure:failure];
}


- (void) decrementSpotsForLot:(DTParkingLot*)lot success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"put" payload:@[@"lots", [lot _id]] parameters:[lot dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}


@end
