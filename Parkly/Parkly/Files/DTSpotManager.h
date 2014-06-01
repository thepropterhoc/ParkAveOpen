//
//  DTSpotManager.h
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/30/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTParkingSpot.h"
#import "DTParkingLot.h"
#import <Foundation/Foundation.h>

@interface DTSpotManager : NSObject

- (void) getSpotsForLot:(DTParkingLot*)lot success: (void (^)(NSURLSessionDataTask *task, NSArray* spots))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) getLotForSpot:(DTParkingSpot*)spot success:(void(^)(NSURLSessionDataTask *task, DTParkingLot* responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) createSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) updateSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) deleteSpot:(DTParkingSpot*)spot success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
