//
//  WelcomeViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"

#import "MeepStyleSheet.h"
#import "TTFixedWidthButton.h"

@implementation WelcomeViewController

@synthesize loginButton;
@synthesize registerButton;

- (void)viewDidLoad {
	self.title = @"Welcome";
    
    [TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	TTFixedWidthButton *button = [TTFixedWidthButton buttonWithStyle:@"embossedButton:" title:@"Login"];
	button.font = [UIFont boldSystemFontOfSize:14];
    button.width = 100;
	[button sizeToFit];
	[button addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[loginButton addSubview:button];
    
    button = [TTFixedWidthButton buttonWithStyle:@"embossedButton:" title:@"Register"];
	button.font = [UIFont boldSystemFontOfSize:14];
    button.width = 100;
	[button sizeToFit];
	[button sizeThatFits:CGSizeMake(100.0f, button.frame.size.height)];
	[button addTarget:self action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[registerButton addSubview:button];
    
	[super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)registerButtonPressed {
	NSLog(@"registerButtonPressed");
	[self.navigationController pushViewController:
	 [self.navigationController registerViewController]
										 animated:YES];
}

- (IBAction)loginButtonPressed {
	NSLog(@"loginButtonPressed");
	[self.navigationController pushViewController:
		[self.navigationController loginViewController]
										 animated:YES];
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


- (void)dealloc {
    [loginButton release];
    [registerButton release];
    [super dealloc];
}


@end
