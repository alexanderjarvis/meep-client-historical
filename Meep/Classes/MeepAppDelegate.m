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

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	configManager = [[ConfigManager alloc] init];
	[configManager loadConfig];
	
	// If the application has run before
	if (![configManager.access_token isEqualToString:@""]) {
		
		// Show menu view
		[self showMenuView];
		
	} else {
		// if no access token
		[self showWelcomeView];
	}
	
    [window makeKeyAndVisible];
}

- (void)showWelcomeView {
	
	if (welcomeNavigationController == nil && welcomeViewController == nil) {
        welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
		welcomeNavigationController = [[WelcomeNavigationController alloc] initWithRootViewController:welcomeViewController];
	}
	[window addSubview:welcomeNavigationController.view];
	[menuNavigationController.view removeFromSuperview];
	
	// When logging out, it's important to clear all resources of the main applicaton view between users
	if (menuNavigationController != nil && menuViewController != nil) {
		[configManager setAccess_token:@""];
		[menuNavigationController release];
		menuNavigationController = nil;
		[menuViewController release];
		menuViewController = nil;
	}
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[configManager saveConfig];
}

@end
