//
//  MeepAppDelegate.m
//  meep
//
//  Created by Alex Jarvis on 17/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MeepAppDelegate.h"

#import "MeepViewController.h"
#import "CLViewController.h"
#import "HTTPDemoViewController.h"

@implementation MeepAppDelegate

@synthesize window;

@synthesize configManager;

@synthesize meepViewController;
@synthesize	clViewController;
@synthesize httpDemoViewController;

@synthesize welcomeNavigationController;


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
	[window addSubview:meepViewController.view];
}

- (void)dealloc {
	[configManager release];
	
    [meepViewController release];
	[clViewController release];
	[httpDemoViewController release];
	
	[welcomeNavigationController release];
    [window release];
    [super dealloc];
}


@end
