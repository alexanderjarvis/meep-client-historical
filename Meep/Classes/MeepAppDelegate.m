//
//  MeepAppDelegate.m
//  meep
//
//  Created by Alex Jarvis on 17/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <YAJL/YAJL.h>

#import "MeepAppDelegate.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "AlertView.h"

@implementation MeepAppDelegate

@synthesize window;
@synthesize configManager;
@synthesize currentUser;
@synthesize welcomeNavigationController;
@synthesize welcomeViewController;
@synthesize menuNavigationController;
@synthesize menuViewController;

+ (MeepAppDelegate *)sharedAppDelegate {
	return [[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UILocalNotification *notification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification != nil) {
        [AlertView showSimpleAlertMessage:@"Launched with a local notification!" withTitle:[notification.userInfo valueForKey:kMeetingIdKey]];
    }
    
	configManager = [[ConfigManager alloc] init];
	[configManager loadConfig];
	
	// If the application has run before
	if (![configManager.accessToken isEqualToString:@""]) {
		
		// Show menu view
		[self showMenuView];
		
	} else {
		// if no access token
		[self showWelcomeView];
	}
	
    [window makeKeyAndVisible];
    
    return NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[configManager saveConfig];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

/*
 * Called when a local notification is received and the application is running.
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"application did receive local notification");
    NSLog(@"notification fire date: %@", notification.fireDate);
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"Fired when active");
        // TODO show alert
        [menuNavigationController showLiveMapFromLocalNotification:notification];
    } else {
        NSLog(@"Fired when inactive - coming from background (or closed) state");
        [menuNavigationController showLiveMapFromLocalNotification:notification];
    }
}

#pragma mark -
#pragma mark MeepAppDelegate

- (void)showWelcomeView {
    
    [LocalNotificationManager cancelAllLocalNotifications];
    
	if (welcomeNavigationController == nil && welcomeViewController == nil) {
        welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
		welcomeNavigationController = [[WelcomeNavigationController alloc] initWithRootViewController:welcomeViewController];
	}
	[window addSubview:welcomeNavigationController.view];
	[menuNavigationController.view removeFromSuperview];
	
	// When logging out, it's important to clear all resources of the main applicaton view between users
    [configManager setAccessToken:@""];
	if (menuNavigationController != nil && menuViewController != nil) {
		[menuNavigationController release];
		menuNavigationController = nil;
		[menuViewController release];
		menuViewController = nil;
	}
}

- (void)showWelcomeViewWithUnauthorisedMessage {
    [self showWelcomeView];
    [AlertView showSimpleAlertMessage:@"You must login again." withTitle:@"Unauthorised"];
}

- (void)showMenuView {
    
	if (menuNavigationController == nil && menuViewController == nil) {
		menuViewController = [[MenuViewController alloc] init];
		menuNavigationController = [[MenuNavigationController alloc] initWithRootViewController:menuViewController];
	}
	[window addSubview:menuNavigationController.view];
	[welcomeNavigationController.view removeFromSuperview];
    
    // When showing the menu, clear the welcome views to save memory.
    if (welcomeNavigationController != nil && welcomeViewController != nil) {
        [welcomeNavigationController release];
        welcomeNavigationController = nil;
        [welcomeViewController release];
        welcomeViewController = nil;
    }
    
}

- (void)dealloc {
	[configManager release];
	[currentUser release];
	[welcomeNavigationController release];
    [welcomeViewController release];
	[menuNavigationController release];
	[menuViewController release];
	[window release];
    [super dealloc];
}

@end
