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
#import "MeepStyleSheet.h"

@implementation MenuViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	// Title
	self.title = @"Meep";
	
	// Logout Button
	logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
													style:UIBarButtonSystemItemDone
												   target:self
												   action:@selector(logoutUserButtonPressed:)];
	self.navigationItem.rightBarButtonItem = logoutButton;
	
	// Add Menu Items
	[TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	launcherView.backgroundColor = RGBCOLOR(224,233,245);
	launcherView.delegate = self;
	launcherView.columnCount = 3;
	
	meetingsItem = [[TTLauncherItem alloc] initWithTitle: @"Meetings"
												   image: @"bundle://Meetings.png"
									                 URL: MeetingsURL];
	[launcherView addItem:meetingsItem animated:NO];
	
	friendsItem = [[TTLauncherItem alloc] initWithTitle: @"Friends"
												  image: @"bundle://Friends.png"
													URL: UsersURL];
	[launcherView addItem:friendsItem animated:NO];
	
	newMeetingItem = [[TTLauncherItem alloc] initWithTitle: @"New Meeting"
													 image: @"bundle://NewMeeting.png"
													   URL: NewMeetingURL];
	[launcherView addItem:newMeetingItem animated:NO];
	
	myDetailsItem = [[TTLauncherItem alloc] initWithTitle: @"My Details"
													image: @"bundle://MyDetails.png"
													  URL: MyDetailsURL];
	[launcherView addItem:myDetailsItem animated:NO];
	
	searchPeopleItem = [[TTLauncherItem alloc] initWithTitle: @"Search People"
													   image: @"bundle://SearchPeople.png"
														 URL: SearchUsersURL];
	[launcherView addItem:searchPeopleItem animated:NO];
	
	friendRequestsItem = [[TTLauncherItem alloc] initWithTitle: @"Friend Requests"
														 image: @"bundle://FriendRequests.png"
														   URL: UserRequestsURL];
	[launcherView addItem:friendRequestsItem animated:NO];
	
	[self.view addSubview:launcherView];
    
    // Request Managers
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	userManager = [[UserManager alloc] initWithAccessToken:configManager.accessToken];
    [userManager setDelegate: self];
	logoutManager = [[LogoutManager alloc] initWithAccessToken:configManager.accessToken];
	[logoutManager setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];
	// WebSocketManager
    webSocketManager = [[WebSocketManager alloc] initWithAccessToken:configManager.accessToken];
    
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[self getUser];
}

- (void)applicationDidBecomeActive:(id)sender {
    [self getUser];
}

/*
 * Gets the current user
 */
- (void)getUser {
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
}

- (void)logoutUserButtonPressed:(id)sender {
	logoutAlertView = [[UIAlertView alloc]
						initWithTitle:@"Logout" 
						message:@"Are you sure that you wish to logout?"
						delegate:self 
						cancelButtonTitle:@"No" 
						otherButtonTitles:@"Yes", nil];
	[logoutAlertView show];
	[logoutAlertView release];
}

- (void)logout {
	[logoutManager logoutUser];
}

- (void)showWelcomeView {
	[[MeepAppDelegate sharedAppDelegate] showWelcomeView];
}

/*
 * Called after a new meeting is created to enable further actions.
 */
- (void)newMeetingCreated {
	meetingsItem.badgeNumber = meetingsItem.badgeNumber + 1;
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
    [webSocketManager release];
	[launcherView release];
	[meetingsItem release];
	[friendsItem release];
	[newMeetingItem release];
	[myDetailsItem release];
	[searchPeopleItem release];
	[friendRequestsItem release];
	[logoutButton release];
	[userManager release];
    [logoutManager release];
    [super dealloc];
}

#pragma mark -
#pragma mark TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	
	MeepAppDelegate *meepAppDelegate = [MeepAppDelegate sharedAppDelegate];
	UserDTO *currentUser = [meepAppDelegate currentUser];
	
	if ([item.URL isEqualToString:MeetingsURL]) {
		meetingsItem.badgeNumber = 0;
		[meepAppDelegate.menuNavigationController showMeetings];
	} else if ([item.URL isEqualToString:NewMeetingURL]) {
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

- (void)getUserSuccessful:(UserDTO *)user {
	NSLog(@"Get user successful");
	[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
	friendRequestsItem.badgeNumber = [[user connectionRequestsFrom] count];
	NSLog(@"connectionRequestsFrom count: %u", [[user connectionRequestsFrom] count]);
    
    [webSocketManager connect];
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
	[AlertView showNetworkAlert:error];
}


@end

