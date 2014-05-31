//
//  DTUserManager.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 5/31/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTUserManager.h"

@implementation DTUserManager


- (void) authenticateUserWithEmail:(NSString*)email andPassword:(NSString*)password success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  NSDictionary* parameters = @{@"email": email,
                               @"password": password};
  
  [[DTModel sharedInstance].networkManager call:@"post" payload:@[@"users", @"session"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    [[DTModel sharedInstance].networkManager checkResponseStatus:responseObject success:^(id responseObject) {
      
      [[[DTModel sharedInstance].dataManager currentUser] setValuesForKeysWithDictionary:responseObject];
      //set the defaults for next time if they aren't the same
      [[DTModel sharedInstance] setDefaultEmail:email];
      [[PDKeychainBindings sharedKeychainBindings] setString:password forKey:@"password"];
      
    } failure:^(NSString *statusCode, NSString *description) {
      NSLog(@"There was an error. status code %@", statusCode);
    }];
    
    if([[responseObject valueForKey:@"err"] isEqualToString:@"nomatch"]) {
      responseObject = @"error";
    } else {
      [[[DTModel sharedInstance].dataManager currentUser] setValuesForKeysWithDictionary:responseObject];
      NSLog(@"!!!!!~~~~~~~~~~~~~~~~~~~%@", [[[DTModel sharedInstance].dataManager currentUser] _id]);
      //set the defaults for next time if they aren't the same
      [[DTModel sharedInstance] setDefaultEmail:email];
      [[PDKeychainBindings sharedKeychainBindings] setString:password forKey:@"password"];
      NSLog(@"default email: %@. You're logged in.", [[DTModel sharedInstance] defaultEmail]);
    }
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
  
}

- (void) authenticateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* aUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self authenticateUserWithEmail:[user email] andPassword:[user password] success:^(NSURLSessionDataTask *task, DTUser *user) {
    success(task, user);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getAllUsers: (void (^)(NSURLSessionDataTask *task, NSArray* allUsers))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"users"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, [[DTModel sharedInstance] parseJSON:responseObject toArrayOfClass:[DTUser class]]);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getUserWithId:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, DTUser* user))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"users", userID] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    DTUser* newUser = [[DTUser alloc] init];
    NSLog(@"%@", responseObject);
    [newUser setValuesForKeysWithDictionary:responseObject];
    success(task, newUser);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) createUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, DTUser* newUser))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"post'" payload:@[@"users"] parameters:[user dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    [self authenticateUser:user success:^(NSURLSessionDataTask *task, DTUser *aUser) {
      success(task, user);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      failure(task, error);
    }];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"New user : %@", [user dictionaryRepresentation]);
    failure(task, error);
  }];
}

- (void) updateUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  [[DTModel sharedInstance].networkManager call:@"put" payload:@[@"users", [user _id]] parameters:[user dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task ,responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) deleteUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [[DTModel sharedInstance].networkManager call:@"delete" payload:@[@"users", [user _id]] parameters:[user dictionaryRepresentation] success:^(NSURLSessionDataTask *task, id responseObject) {
    success(task, responseObject);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (NSString*) getUsernameForUser:(DTUser*)user {
  return [self getUsernameForUserID:[user _id]];
}

- (NSString*) getUsernameForUserID:(NSString*)userID {
  return @"REMOVE THIS!!!!! THIS NEEDS TO CHANGE TO THE NEW VERSION!";
}

- (void) getUsernameForUser:(DTUser*)user success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  [self getUsernameForUserID:[user _id] success:^(NSURLSessionDataTask *task, NSString *name) {
    success(task, name);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}

- (void) getUsernameForUserID:(NSString*)userID success: (void (^)(NSURLSessionDataTask *task, NSString* name))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  
  [[DTModel sharedInstance].networkManager call:@"get" payload:@[@"username", userID] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSString* name = [NSString stringWithFormat:@"%@ %@",[responseObject valueForKey:@"firstName"], [responseObject valueForKey:@"lastName"]];
    success(task, name);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(task, error);
  }];
}


@end
