//
//  DTCarManager.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/31/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTCarManager.h"

@implementation DTCarManager


- (void) getCarsForUser:(DTUser *)user success:(void (^)(NSURLSessionDataTask *task, NSArray* cars))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
  
  if ([[DTCache sharedInstance] hasCarsForUser:user]) {
    success([[NSURLSessionDataTask alloc] init], [[DTCache sharedInstance] carsForUser:user]);
  } else {
    [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"users", [user _id], @"cars"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      NSArray* cars = [[DTModel sharedInstance] parseJSON:responseObject toArrayOfClass:[DTCar class]];
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
  
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"users", [car user_id], @"cars", [car _id]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    DTCar* newCar = [[DTCar alloc] init];
    [newCar setValuesForKeysWithDictionary:responseObject];
    success(task, newCar);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) createCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"post" payload:@[@"users", [car user_id], @"cars"] parameters:[car dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    
    //add car to cache
    [[DTCache sharedInstance] addCars:[NSArray arrayWithObject:car] forUser:[[DTModel sharedInstance] currentUser]];
    
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) updateCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"post" payload:@[@"users", [car user_id], @"cars", [car _id]] parameters:[car dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) deleteCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"delete" payload:@[@"users", [car user_id], @"cars", [car _id]] parameters:[car dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

@end
