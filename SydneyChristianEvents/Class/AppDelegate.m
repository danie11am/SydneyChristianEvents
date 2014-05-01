//
//  AppDelegate.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 6/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import "Flurry.h"

#import "AppDelegate.h"
#import "EventListViewController.h"

@implementation AppDelegate

NSString * const FLURRY_API_KEY = @""; // To be replaced before submitting to app store.


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    EventListViewController *eventListVC = [[EventListViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: eventListVC];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];

    //self.window.backgroundColor = [UIColor yellowColor];

    [self setDefaultValues];
    
    // iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:FLURRY_API_KEY]; // "Catch - dev" project

    return YES;
}
							


- (void) setDefaultValues
{
    
	// Get the path to preference file
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [path stringByAppendingPathComponent:@"PreferenceDefaults.plist"];
    
	NSDictionary *prefDefaults = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    // Save the dictionary into the Registration Domain of the NSUserDefaults object.
	[[NSUserDefaults standardUserDefaults] registerDefaults:prefDefaults];
    
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

@end
