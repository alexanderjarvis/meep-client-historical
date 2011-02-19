//
//  WelcomeNavigationController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WelcomeViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface WelcomeNavigationController : UINavigationController {
	
	WelcomeViewController *welcomeViewController;
	RegisterViewController *registerViewController;
	LoginViewController *loginViewController;

}

@property (nonatomic, retain) WelcomeViewController *welcomeViewController;
@property (nonatomic, retain) RegisterViewController *registerViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;

@end
