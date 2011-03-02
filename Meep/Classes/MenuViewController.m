//
//  MenuViewController.m
//  meep
//
//  Created by Alex Jarvis on 16/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

#import "MeepAppDelegate.h"
#import "LogoutManager.h"
#import "AlertView.h"

@implementation MenuViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	// Title
	self.title = @"Menu";
	
	// User Manager
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	userManager = [[UserManager alloc] initWithAccessToken:configManager.access_token];
	[userManager setDelegate: self];
	
	// Logout Button
	logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
													style:UIBarButtonSystemItemDone
												   target:self
												   action:@selector(logoutUserButtonPressed:)];
	self.navigationItem.rightBarButtonItem = logoutButton;
	
	// Add Menu Items
	launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	launcherView.backgroundColor = [UIColor blackColor];
	launcherView.delegate = self;
	launcherView.columnCount = 3;
	
	TTLauncherItem* item =
	[[TTLauncherItem alloc] initWithTitle: @"Meetings"
									image: @"bundle://Icon.png"
									  URL: @"mp://meetings"];
	[launcherView addItem:item animated:NO];
	
	item =
	[[TTLauncherItem alloc] initWithTitle: @"Friends"
									image: @"bundle://Icon.png"
									  URL: UsersURL];
	[launcherView addItem:item animated:NO];
	
	item =
	[[TTLauncherItem alloc] initWithTitle: @"New Meeting"
									image: @"bundle://Icon.png"
									  URL: NewMeetingURL];
	[launcherView addItem:item animated:NO];
	
	item =
	[[TTLauncherItem alloc] initWithTitle: @"My Details"
									image: @"bundle://Icon.png"
									  URL: @"mp://mydetails"];
	[launcherView addItem:item animated:NO];
	
	item =
	[[TTLauncherItem alloc] initWithTitle: @"Search People"
									image: @"bundle://Icon.png"
									  URL: SearchUsersURL];
	[launcherView addItem:item animated:NO];
	
	connectionRequestsItem = [[TTLauncherItem alloc] initWithTitle: @"Friend Requests"
															 image: @"bundle://Icon.png"
															   URL: UserRequestsURL];
	[launcherView addItem:connectionRequestsItem animated:NO];
	
	TT_RELEASE_SAFELY(item);
	[self.view addSubview:launcherView];
	
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	// Get the current user
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
}

- (void)logoutUserButtonPressed:(id)sender {
	logoutAlertView = [[UIAlertView alloc]
						initWithTitle:@"Logout" 
						message:@"Are you sure that you wish to logout?"
						delegate:self 
						cancelButtonTitle:@"Cancel" 
						otherButtonTitles:@"Logout", nil];
	[logoutAlertView show];
	[logoutAlertView release];
}

- (void)logout {
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *accessToken = [[meepAppDelegate configManager] access_token];
	LogoutManager *logoutManager = [[LogoutManager alloc] initWithAccessToken: accessToken];
	[logoutManager setDelegate:self];
	[logoutManager logoutUser];
}

- (void)showWelcomeView {
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[[meepAppDelegate configManager] setAccess_token:@""];
	[meepAppDelegate showWelcomeView];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	
	MeepAppDelegate *meepAppDelegate = [MeepAppDelegate sharedAppDelegate];
	User *currentUser = [meepAppDelegate currentUser];
	
	if ([item.URL isEqualToString:NewMeetingURL]) {
		// Check that the current user has connections to make a meeting with.
		if ([currentUser.connections count] > 0) {
			[meepAppDelegate.menuNavigationController showNewMeetingLocation];
		} else {
			[AlertView showNoUsersAlert];
		}
	} else if ([item.URL isEqualToString:SearchUsersURL]) {
		[meepAppDelegate.menuNavigationController showSearchUsers];
	} else if ([item.URL isEqualToString:UserRequestsURL]) {
		[meepAppDelegate.menuNavigationController showUserRequests];
	} else if ([item.URL isEqualToString:UsersURL]) {
		[meepAppDelegate.menuNavigationController showUsers];
	}
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
												 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
												 target:launcher action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:logoutButton animated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView isEqual:logoutAlertView]) {
		switch (buttonIndex) {
			case 0:
				// Cancel
				break;
			case 1:
				// Logout
				[self logout];
				break;
			default:
				break;
		}
	}
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(User *)user {
	NSLog(@"Get user successful");
	[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
	connectionRequestsItem.badgeNumber = [[user connectionRequestsFrom] count];
	NSLog(@"connectionRequestsFrom count: %u", [[user connectionRequestsFrom] count]);
}

- (void)getUserFailedWithError:(NSError *)error {
	[self showWelcomeView];
	
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
	[self showWelcomeView];
}

#pragma mark -
#pragma mark LogoutManagerDelegate

- (void)logoutUserSuccessful {
	[self showWelcomeView];
}

- (void)logoutUserFailedWithError:(NSError *)error {
	[self showWelcomeView];
}

- (void)logoutUserFailedWithNetworkError:(NSError *)error {
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[[meepAppDelegate menuNavigationController] showNetworkAlert: error];
}


@end

