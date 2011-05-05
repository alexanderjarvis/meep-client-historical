//
//  WelcomeViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MeepAppDelegate.h"
#import "MeepStyleSheet.h"
#import "TTFixedWidthButton.h"

@implementation WelcomeViewController

@synthesize loginButton;
@synthesize registerButton;
@synthesize registerViewController;
@synthesize loginViewController;

- (void)viewDidLoad {
    
	self.title = @"Welcome";
    
    [TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	TTFixedWidthButton *button = [TTFixedWidthButton buttonWithStyle:@"embossedButton:" title:@"Login"];
	button.font = [UIFont boldSystemFontOfSize:14];
    button.width = 200;
	[button sizeToFit];
	[button addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[loginButton addSubview:button];
    
    button = [TTFixedWidthButton buttonWithStyle:@"embossedButton:" title:@"Register"];
	button.font = [UIFont boldSystemFontOfSize:14];
    button.width = 200;
	[button sizeToFit];
	[button sizeThatFits:CGSizeMake(100.0f, button.frame.size.height)];
	[button addTarget:self action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[registerButton addSubview:button];
    
    registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)registerButtonPressed {
	[self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)loginButtonPressed {
	[self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [loginButton release];
    [registerButton release];
    [registerViewController release];
	[loginViewController release];
    [super dealloc];
}

@end
