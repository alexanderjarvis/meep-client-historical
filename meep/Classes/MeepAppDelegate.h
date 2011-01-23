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

@class MeepViewController;
@class CLViewController;
@class HTTPDemoViewController;

@interface MeepAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	ConfigManager *configManager;
	
	
    MeepViewController *meepViewController;
	CLViewController *clViewController;
	HTTPDemoViewController *httpDemoViewController;
	
	WelcomeNavigationController *welcomeNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) ConfigManager *configManager;

@property (nonatomic, retain) IBOutlet MeepViewController *meepViewController;
@property (nonatomic, retain) IBOutlet CLViewController *clViewController;
@property (nonatomic, retain) IBOutlet HTTPDemoViewController *httpDemoViewController;

@property (nonatomic, retain) IBOutlet WelcomeNavigationController *welcomeNavigationController;

- (void)showWelcomeView;

- (void)showMenuView;

@end

