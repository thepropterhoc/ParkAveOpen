//
//  DTNetworkManager.h
//  Parkly
//
//  Created by CCEW on 2/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "DTDataManager.h"

@interface DTNetworkManager : AFHTTPSessionManager

+ (instancetype) sharedInstance;

- (void) call:(NSString*)action one:(NSString*)one parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) call:(NSString*)action one:(NSString*)one two:(NSString*)two parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) call:(NSString*)action one:(NSString*)one two:(NSString*)two three:(NSString*)three parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) call:(NSString*)action one:(NSString*)one two:(NSString*)two three:(NSString*)three four:(NSString*)four parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) call:(NSString*)action one:(NSString*)one two:(NSString*)two three:(NSString*)three four:(NSString*)four five:(NSString*)five parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) call:(NSString*)action one:(NSString*)one two:(NSString*)two three:(NSString*)three four:(NSString*)four five:(NSString*)five six:(NSString*)six parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - Helper Methods

- (void) genericCall:(NSString*)action path:(NSString*)path parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericGet:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericPost:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericPut:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) genericDelete:(NSString*)pathString parameters:(NSDictionary*)parameters success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
