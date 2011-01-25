//
//  meepAppDelegate.h
//  meep
//
//  Created by Alex Jarvis on 17/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConfigManager.h"

#import "WelcomeNavigationController.h"
#import "MenuViewController.h"

@class CLViewController;
@class HTTPDemoViewController;

@interface MeepAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	ConfigManager *configManager;
	
	WelcomeNavigationController *welcomeNavigationController;
	MenuViewController *menuViewController;
	
	
	// old
	CLViewController *clViewController;
	HTTPDemoViewController *httpDemoViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ConfigManager *configManager;
@property (nonatomic, retain) IBOutlet WelcomeNavigationController *welcomeNavigationController;
@property (nonatomic, retain) IBOutlet MenuViewController *menuViewController;
@property (nonatomic, retain) IBOutlet CLViewController *clViewController;
@property (nonatomic, retain) IBOutlet HTTPDemoViewController *httpDemoViewController;

- (void)showWelcomeView;

- (void)showMenuView;

@end

