//
//  meepAppDelegate.m
//  meep
//
//  Created by Alex Jarvis on 17/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "meepAppDelegate.h"

#import "MeepViewController.h"
#import "CLViewController.h"
#import "HTTPDemoViewController.h"

@implementation meepAppDelegate

@synthesize window;

@synthesize meepViewController;
@synthesize	clViewController;
@synthesize httpDemoViewController;

@synthesize welcomeNavigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
    //[window addSubview:meepViewController.view];
	//[window addSubview:clViewController.view];
	//[window addSubview:httpDemoViewController.view];
	
	
	// if no access token
	[window addSubview:welcomeNavigationController.view];	
	
	
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [meepViewController release];
	[clViewController release];
	[httpDemoViewController release];
	
	[welcomeNavigationController release];
    [window release];
    [super dealloc];
}


@end
