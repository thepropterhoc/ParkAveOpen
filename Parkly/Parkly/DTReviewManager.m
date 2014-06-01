//
//  DTReviewManager.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/31/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTReviewManager.h"
#import "DTModel.h"
#import "DTCache.h"

@implementation DTReviewManager

- (void) getAllReviews: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"reviews"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getReviewsForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSArray* reviews))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  if([[DTCache sharedInstance] hasReviewsForUser:user]){
    success(nil, [[DTCache sharedInstance] reviewsForUser:user]);
    return;
  }
  
  NSLog(@"%@", user._id);
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"users", [user _id], @"reviews"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *reviews = [[DTModel sharedInstance] parseJSON:responseObject toArrayOfClass:[DTReview class]];
    [[DTCache sharedInstance] addReviews:reviews forUser:user];
    success(task, reviews);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) createReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) updateReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

- (void) deleteReview:(DTReview*)review success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  NSLog(@"%@ not implemented", NSStringFromSelector(_cmd));
}

@end
