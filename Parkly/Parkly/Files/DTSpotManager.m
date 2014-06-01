//
//  DTSpotManager.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/30/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTSpotManager.h"
#import "DTCache.h"
#import "DTModel.h"

@implementation DTSpotManager

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
  
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"users", [lot user_id], @"lots", [lot _id], @"spots"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray* spotArray = [[DTModel sharedInstance] parseJSON:responseObject toArrayOfClass:[DTParkingSpot class]];
    [[DTCache sharedInstance] addSpots:spotArray forLot:lot];
    success(task, spotArray);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}


- (void) getLotForSpot:(DTParkingSpot*)spot success:(void (^)(NSURLSessionDataTask *task, DTParkingLot *responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  [[DTModel sharedInstance] getAllLots:^(NSURLSessionDataTask *task, NSArray *allLots) {
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


@end
