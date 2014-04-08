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
        
        // Do any other initialisation stuff here
        sharedInstance.currentUser = [[DTUser alloc] init];
        sharedInstance.currentUser._id = @"-1";
        
    });
    return sharedInstance;
}

- (void) loginUser:(DTUser*)user {
    self.currentUser = user;
}

- (void) logoutUser {
//#warning this needs to be different
    self.currentUser = [[DTUser alloc] init];
    self.currentUser._id = @"-1";
}

- (BOOL) isUserLoggedIn {
    return ![self.currentUser._id isEqualToString:@"-1"];
}

- (DTUser*) defaultUser {
    DTUser* mrDefault = [[DTUser alloc] init];
    mrDefault.email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    mrDefault.password = [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"password"];
    return mrDefault;
}

@end
