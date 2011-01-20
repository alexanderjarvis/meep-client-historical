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
@synthesize registerViewController;
@synthesize loginViewController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"WelcomeNavigationController loaded");
	
	// Always load the root view controller
	welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
	[self pushViewController:welcomeViewController animated:NO];
	
	registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)showValidationAlert:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Oops!" 
						  message:message
						  delegate:self 
						  cancelButtonTitle:@"Dismiss" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)showNetworkAlert:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Network Error" 
						  message:[error localizedDescription]
						  delegate:self
						  cancelButtonTitle:@"Dismiss" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)dealloc {
	[welcomeViewController release];
	[registerViewController release];
	[loginViewController release];
	
    [super dealloc];
}


@end
