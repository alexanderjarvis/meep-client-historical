//
//  WelcomeNavigationController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WelcomeNavigationController.h"

@implementation WelcomeNavigationController

@synthesize welcomeViewController;

/*
 * Default behaviour overriden so that a reference to the rootViewController can be stored locally.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
	if (self) {
		if ([rootViewController isKindOfClass:[WelcomeViewController class]]) {
			self.welcomeViewController = (WelcomeViewController *)welcomeViewController;
		}
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {	
    [super viewDidUnload];
}

- (void)dealloc {
	[welcomeViewController release];
    [super dealloc];
}


@end
