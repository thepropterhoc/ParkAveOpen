//
//  DTAppDelegate.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/18/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTAppDelegate.h"
#import "DTModel.h"

@implementation DTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  if([[DTModel sharedInstance] defaultsExist]){
    [[DTModel sharedInstance] authenticateUserWithEmail:[[DTModel sharedInstance] defaultEmail] andPassword:[[DTModel sharedInstance] defaultPassword] success:^(NSURLSessionDataTask *task, DTUser *aUser) {
      NSLog(@"DIDFINISHLAUNCHINGWITHOPTIONS : Successfully logged default user in");
        
        [[DTModel sharedInstance] addCreditCard:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"added credit card");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"added credit card");
        }];
        
        [[DTModel sharedInstance] getLotsNearLatitude:-35.0 andLongitude:92.0 withDistance:15000.0 success:^(NSURLSessionDataTask *task, NSArray* lotArray) {
            NSLog(@"%@", lotArray);
            NSLog(@"working?");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      NSLog(@"DIDFINISHLAUNCHINGWITHOPTIONS : Unable to log default user in");
    }];
  }
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  [[DTModel sharedInstance] scrubTheCache];
  if([[DTModel sharedInstance] userIsLoggedIn]){
    [[DTModel sharedInstance] logoutUser];
    NSLog(@"DIDENTERBACKGROUND : Logged user out");
  }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  if([[DTModel sharedInstance] defaultsExist]){
    [[DTModel sharedInstance] authenticateUserWithEmail:[[DTModel sharedInstance] defaultEmail] andPassword:[[DTModel sharedInstance] defaultPassword] success:^(NSURLSessionDataTask *task, DTUser *aUser) {
      NSLog(@"WILLENTERFOREGROUND : Logged user in successfully");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      NSLog(@"WILLENTERFOREGROUND : Unable to default log in");
    }];
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
  
  if([[DTModel sharedInstance] defaultsExist] && [[DTModel sharedInstance] userHasAccount] && ![[DTModel sharedInstance] userIsLoggedIn]){
    [[DTModel sharedInstance] authenticateUserWithEmail:[[DTModel sharedInstance] defaultEmail] andPassword:[[DTModel sharedInstance] defaultPassword] success:^(NSURLSessionDataTask *task, DTUser *aUser) {
      NSLog(@"DIDBECOMEACTIVE : Logged user in successfully");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      NSLog(@"DIDBECOMEACTIVE : Unable to default log in");
    }];
  }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  [[DTModel sharedInstance] scrubTheCache];
  if([[DTModel sharedInstance] userIsLoggedIn]){
    [[DTModel sharedInstance] logoutUser];
    NSLog(@"WILLTERMINATE : Logged user out");
  }
}

@end
