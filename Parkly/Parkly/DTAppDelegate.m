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

      [[DTModel sharedInstance] addCreditCard:^(NSURLSessionDataTask *task, id responseObject) {
        ;
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ;
      }];
      
      [[DTModel sharedInstance] getUsernameForUser:[[DTModel sharedInstance] currentUser] success:^(NSURLSessionDataTask *task, NSString *name) {
        
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
      }];
      

      
      [[DTModel sharedInstance] getLotsandSpotsForCurrentLocationWithDistance:150000.0f success:^(NSURLSessionDataTask *task, id responseObject) {
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
          
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
    
  }
  [[DTModel sharedInstance] stopUpdatingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  if([[DTModel sharedInstance] defaultsExist]){
    [[DTModel sharedInstance] authenticateUserWithEmail:[[DTModel sharedInstance] defaultEmail] andPassword:[[DTModel sharedInstance] defaultPassword] success:^(NSURLSessionDataTask *task, DTUser *aUser) {
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
    }];
  }
  
  [[DTModel sharedInstance] startUpdatingLocation];
  [[DTModel sharedInstance] getLotsandSpotsForCurrentLocationWithDistance:150000.0 success:^(NSURLSessionDataTask *task, id responseObject) {
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
  }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [[DTModel sharedInstance] startUpdatingLocation];
  if([[DTModel sharedInstance] defaultsExist] && [[DTModel sharedInstance] userHasAccount] && ![[DTModel sharedInstance] userIsLoggedIn]){
    [[DTModel sharedInstance] authenticateUserWithEmail:[[DTModel sharedInstance] defaultEmail] andPassword:[[DTModel sharedInstance] defaultPassword] success:^(NSURLSessionDataTask *task, DTUser *aUser) {
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
    }];
  }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  [[DTModel sharedInstance] scrubTheCache];
  if([[DTModel sharedInstance] userIsLoggedIn]){
    [[DTModel sharedInstance] logoutUser];
    
  }
  [[DTModel sharedInstance] stopUpdatingLocation];
}

@end
