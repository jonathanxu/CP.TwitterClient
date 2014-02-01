//
//  CPAppDelegate.m
//  CP.TwitterClient
//
//  Created by Jonathan Xu on 1/31/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPAppDelegate.h"
#import "Models/CPUser.h"
#import "Views/CPLaunchViewController.h"

@interface CPAppDelegate ()
@property (strong, nonatomic) CPLaunchViewController *launchViewController;
@end

@implementation CPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.currentUser = [[CPUser alloc] init];
    if ([self.currentUser isLoggedIn]) {
        NSLog(@"CPAppDelegate.application:didFinishLaunchingWithOptions: user is logged in");
    }
    else {
        NSLog(@"CPAppDelegate.application:didFinishLaunchingWithOptions: user is not logged in");
        self.window.rootViewController = self.launchViewController;
        self.launchViewController.currentUser = self.currentUser;
    }
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Launch and Timeline View Controllers

@synthesize launchViewController = _launchViewController;

- (CPLaunchViewController *)launchViewController
{
    if (!_launchViewController) {
        _launchViewController = [[CPLaunchViewController alloc] init];
    }
    return _launchViewController;
}

@end
