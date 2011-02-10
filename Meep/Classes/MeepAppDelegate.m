//
//  MeepAppDelegate.m
//  meep
//
//  Created by Alex Jarvis on 17/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MeepAppDelegate.h"

#import "UserManager.h"
#import "CLViewController.h"

#import <YAJL/YAJL.h>

@implementation MeepAppDelegate

@synthesize window;
@synthesize configManager;
@synthesize welcomeNavigationController;
@synthesize menuNavigationController;
@synthesize	clViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	configManager = [[ConfigManager alloc] init];
	[configManager loadConfig];
	
	// If the application has run before
	if (![configManager.access_token isEqualToString:@""]) {
		
		// Check access token
		UserManager *userManager = [[UserManager alloc] initWithAccessToken:configManager.access_token];
		[userManager setDelegate: self];
		[userManager getUser:configManager.email];
		
		// If successful, show menu view
		[self showMenuView];
		
	} else {
		// if no access token
		[self showWelcomeView];
	}
	
    [window makeKeyAndVisible];
}

- (void)showWelcomeView {
	if (welcomeNavigationController == nil) {
		welcomeNavigationController = [[WelcomeNavigationController alloc] init];
	}
	[window addSubview:welcomeNavigationController.view];
	[menuNavigationController.view removeFromSuperview];
}

- (void)showMenuView {
	if (menuNavigationController == nil) {
		menuNavigationController = [[MenuNavigationController alloc] init];
	}
	[window addSubview:menuNavigationController.view];
	[welcomeNavigationController.view removeFromSuperview];
}

- (void)dealloc {
	[configManager release];
	
	[welcomeNavigationController release];
	[menuNavigationController release];
	
	[clViewController release];
	
	[window release];
	
    [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[configManager saveConfig];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (UserDTO *)getUserSuccessful {
	
}

- (void)getUserFailedWithError:(NSError *)error {

}

- (void)getUserFailedWithNetworkError:(NSError *)error {

}


@end
