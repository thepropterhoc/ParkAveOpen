//
//  DTDataManager.m
//  Parkly
//
//  Created by CCEW on 2/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTDataManager.h"
#import "PDKeychainBindings.h"

@implementation DTDataManager

+ (instancetype)sharedInstance {
    //  Static local predicate must be initialized to 0
    static DTDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[[self class] alloc] init];
      sharedInstance.currentUser = nil;
      sharedInstance.currentUserCars = nil;
    });
    return sharedInstance;
}

- (void) logoutUser {
//#warning this needs to be different
  self.currentUser = nil;
  self.currentUserCars = @[];
}

- (BOOL) isUserLoggedIn {
    return self.currentUser != nil;
}

- (DTUser*) defaultUser {
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"email"] != nil && [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"password"] != nil) {
    DTUser* mrDefault = [[DTUser alloc] init];
    mrDefault.email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    mrDefault.password = [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"password"];
    return mrDefault;
  } else {
    return nil;
  }
}

- (DTCar*) defaultCar {
    return [[DTCar alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"car"]];
}

- (void) setDefaultCar:(DTCar*)car {
    [[NSUserDefaults standardUserDefaults] setObject:[car dictionaryRepresentation] forKey:@"car"];
}

-(void)setDefaultUser:(DTUser *)user
{
  if(user){
    NSLog(@"Set default user to %@, %@", user.email, user.password);
    [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:@"email"];
    [[PDKeychainBindings sharedKeychainBindings] setObject:user.password forKey:@"password"];
  } else {
    NSLog(@"Set default user to nil");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"password"];
  }
}

@end
