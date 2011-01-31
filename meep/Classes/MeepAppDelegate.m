//
//  MeepAppDelegate.m
//  meep
//
//  Created by Alex Jarvis on 17/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MeepAppDelegate.h"

#import "CLViewController.h"
#import "HTTPDemoViewController.h"

@implementation MeepAppDelegate

@synthesize window;
@synthesize configManager;
@synthesize welcomeNavigationController;
@synthesize menuNavigationController;
@synthesize	clViewController;
@synthesize httpDemoViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	configManager = [[ConfigManager alloc] init];
	[configManager loadConfig];
	
	// If the application has run before
	if (![configManager.access_token isEqualToString:@""]) {
		
		// Check access token
		
		// If successful, show menu view
		[self showMenuView];
		
	} else {
		// if no access token
		[self showWelcomeView];
	}
	
    [window makeKeyAndVisible];
}

- (void)showWelcomeView {
	[window addSubview:welcomeNavigationController.view];
}

- (void)showMenuView {
	[window addSubview:menuNavigationController.view];
}

- (void)dealloc {
	[configManager release];
	
	[welcomeNavigationController release];
	[menuNavigationController release];
	
	[clViewController release];
	[httpDemoViewController release];
	
	[window release];
	
    [super dealloc];
}


@end
