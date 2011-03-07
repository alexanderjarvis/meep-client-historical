//
//  WelcomeNavigationController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WelcomeViewController.h"

@interface WelcomeNavigationController : UINavigationController {
	
	WelcomeViewController *welcomeViewController;

}

@property (nonatomic, retain) WelcomeViewController *welcomeViewController;

@end
