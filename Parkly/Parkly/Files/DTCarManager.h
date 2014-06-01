//
//  DTCarManager.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/31/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTUser.h"
#import "DTCar.h"
#import <Foundation/Foundation.h>

@interface DTCarManager : NSObject

- (void) getCarsForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSArray* cars))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, DTCar* aCar))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) createCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) updateCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) deleteCar:(DTCar*)car success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
