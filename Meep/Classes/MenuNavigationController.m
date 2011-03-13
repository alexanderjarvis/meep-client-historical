//
//  MenuNavigationController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuNavigationController.h"


@implementation MenuNavigationController

@synthesize menuViewController;
@synthesize meetingsViewController;
@synthesize usersViewController;
@synthesize newMeetingLocationController;
@synthesize newMeetingDateAndTimeController;
@synthesize newMeetingUsersController;
@synthesize searchUsersViewController;
@synthesize userRequestsViewController;
@synthesize liveMapViewController;

#pragma mark -
#pragma mark View lifecycle

/*
 * Default behaviour overriden so that a reference to the rootViewController can be stored locally.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
	if (self) {
		if ([rootViewController isKindOfClass:[MenuViewController class]]) {
			menuViewController = [(MenuViewController *)rootViewController retain];
		}
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showMeetings {
	if (meetingsViewController == nil) {
		meetingsViewController = [[MeetingsViewController alloc] initWithNibName:@"MeetingsViewController" bundle:nil];
	}
	[self pushViewController:meetingsViewController animated:YES];
}

- (void)showUsers {
	if (usersViewController == nil) {
		usersViewController = [[UsersViewController alloc] initWithNibName:@"UsersViewController" bundle:nil];
	}
	[self pushViewController:usersViewController animated:YES];
}

- (void)showNewMeetingLocation {
	if (newMeetingLocationController == nil) {
		newMeetingLocationController = [[NewMeetingLocationController alloc] initWithNibName:@"NewMeetingLocationController" bundle:nil];
	}
	[self pushViewController:newMeetingLocationController animated:YES];
}

- (void)showNewMeetingDateAndTime {
	if (newMeetingDateAndTimeController == nil) {
		newMeetingDateAndTimeController = [[NewMeetingDateAndTimeController alloc] initWithNibName:@"NewMeetingDateAndTimeController" bundle:nil];
	}
	[self pushViewController:newMeetingDateAndTimeController animated:YES];
}

- (void)showNewMeetingUsers {
	if (newMeetingUsersController == nil) {
		newMeetingUsersController = [[NewMeetingUsersController alloc] initWithNibName:@"NewMeetingUsersController" bundle:nil];
	}
	[self pushViewController:newMeetingUsersController animated:YES];
}

- (void)showSearchUsers {
	if (searchUsersViewController == nil) {
		searchUsersViewController = [[SearchUsersViewController alloc] initWithNibName:@"SearchUsersViewController" bundle:nil];
	}
	[self pushViewController:searchUsersViewController animated:YES];
}

- (void)showUserRequests {
	if (userRequestsViewController == nil) {
		userRequestsViewController = [[UserRequestsViewController alloc] initWithNibName:@"UserRequestsViewController" bundle:nil];
	}
	[self pushViewController:userRequestsViewController animated:YES];
}

- (void)showLiveMap {
	if (liveMapViewController == nil) {
		liveMapViewController = [[LiveMapViewController alloc] initWithNibName:@"LiveMapViewController" bundle:nil];
	}
	[self pushViewController:liveMapViewController animated:YES];
}

/*
 * To be called just after a meeting is successfully created in order to reset the meeting
 * creation views by releasing them.
 */
- (void)newMeetingCreated {
	[self popToRootViewControllerAnimated:YES];
	[newMeetingUsersController release];
	newMeetingUsersController = nil;
	[newMeetingDateAndTimeController release];
	newMeetingDateAndTimeController = nil;
	[newMeetingLocationController release];
	newMeetingLocationController = nil;
	[menuViewController newMeetingCreated];
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
	[menuViewController release];
	[meetingsViewController release];
	[usersViewController release];
	[newMeetingLocationController release];
	[newMeetingDateAndTimeController release];
	[newMeetingUsersController release];
	[searchUsersViewController release];
	[userRequestsViewController release];
    [liveMapViewController release];
    [super dealloc];
}

@end

