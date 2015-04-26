//
//  testDiplom
//
//  Created by Алтунин Михаил on 09.02.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//


#import "AppDelegate.h"
#import "AMGroupsTableViewController.h"
#import "AMDataManager.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    // Override point for customization after application launch.
    //[[AMDataManager sharedManager]deleteAllObjects];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}

// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"Напоминание:"  message:notification.alertBody
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [notificationAlert show];
    // NSLog(@"didReceiveLocalNotification");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [application setApplicationIconBadgeNumber:0];
    
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

#pragma mark - Backgrounding Methods -
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
	self.backgroundSessionCompletionHandler = completionHandler;
}


@end
