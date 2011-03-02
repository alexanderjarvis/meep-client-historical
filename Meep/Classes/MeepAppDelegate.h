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
#import "MenuNavigationController.h"

@interface MeepAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	ConfigManager *configManager;
	
	WelcomeNavigationController *welcomeNavigationController;
	MenuNavigationController *menuNavigationController;	
	
	User *currentUser;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ConfigManager *configManager;
@property (nonatomic, retain) IBOutlet WelcomeNavigationController *welcomeNavigationController;
@property (nonatomic, retain) IBOutlet MenuNavigationController *menuNavigationController;
@property (nonatomic, retain) User *currentUser;

+ (MeepAppDelegate *)sharedAppDelegate;

- (void)showWelcomeView;

- (void)showMenuView;

@end

