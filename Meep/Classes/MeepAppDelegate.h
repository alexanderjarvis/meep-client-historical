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
#import "WelcomeViewController.h"
#import "MenuNavigationController.h"
#import "MenuViewController.h"

@interface MeepAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	ConfigManager *configManager;
	WelcomeNavigationController *welcomeNavigationController;
    WelcomeViewController *welcomeViewController;
	MenuNavigationController *menuNavigationController;	
	MenuViewController *menuViewController;
	UserDTO *currentUser;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ConfigManager *configManager;
@property (nonatomic, retain) WelcomeNavigationController *welcomeNavigationController;
@property (nonatomic, retain) WelcomeViewController *welcomeViewController;
@property (nonatomic, retain) MenuNavigationController *menuNavigationController;
@property (nonatomic, retain) MenuViewController *menuViewController;
@property (nonatomic, retain) UserDTO *currentUser;

+ (MeepAppDelegate *)sharedAppDelegate;

- (void)showWelcomeView;
- (void)showMenuView;

@end

