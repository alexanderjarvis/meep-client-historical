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
#import "LocalNotificationManager.h"

@implementation MenuViewController

@synthesize friendRequestsItem;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    liveMapItem = [[TTLauncherItem alloc] initWithTitle: @"Live Map"
                                                           image: @"bundle://Icon.png"
                                                            URL: LiveMapURL];
    [launcherView addItem:liveMapItem animated:NO];
	
	[self.view addSubview:launcherView];
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
	[launcherView release];
	[meetingsItem release];
	[friendsItem release];
	[newMeetingItem release];
	[myDetailsItem release];
	[searchPeopleItem release];
	[friendRequestsItem release];
    [liveMapItem release];
	[logoutButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark MenuViewController

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

/*
 * Called after a new meeting is created to enable further actions.
 */
- (void)newMeetingCreated {
	meetingsItem.badgeNumber = meetingsItem.badgeNumber + 1;
}

#pragma mark -
#pragma mark TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	
	MeepAppDelegate *meepAppDelegate = [MeepAppDelegate sharedAppDelegate];
	UserDTO *currentUser = [meepAppDelegate currentUser];
	
	if ([item.URL isEqualToString:MeetingsURL]) {
		meetingsItem.badgeNumber = 0;
		[meepAppDelegate.menuNavigationController showMeetingsViewAnimated:YES];
	} else if ([item.URL isEqualToString:NewMeetingURL]) {
		// Check that the current user has connections to make a meeting with.
		if ([currentUser.connections count] > 0) {
			[meepAppDelegate.menuNavigationController showNewMeetingLocationAnimated:YES];
		} else {
			[AlertView showNoUsersAlert];
		}
	} else if ([item.URL isEqualToString:SearchUsersURL]) {
		[meepAppDelegate.menuNavigationController showSearchUsersViewAnimated:YES];
	} else if ([item.URL isEqualToString:UserRequestsURL]) {
		[meepAppDelegate.menuNavigationController showUserRequestsViewAnimated:YES];
	} else if ([item.URL isEqualToString:UsersURL]) {
		[meepAppDelegate.menuNavigationController showUsersViewAnimated:YES];
	} else if ([item.URL isEqualToString:LiveMapURL]) {
        [meepAppDelegate.menuNavigationController showLiveMapViewAnimated:YES];
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
				[[[MeepAppDelegate sharedAppDelegate] menuNavigationController] logout:NO];
				break;
			default:
				break;
		}
	}
}

@end

