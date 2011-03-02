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
@synthesize usersViewController;
@synthesize newMeetingLocationController;
@synthesize newMeetingDateAndTimeController;
@synthesize newMeetingUsersController;
@synthesize searchUsersViewController;
@synthesize userRequestsViewController;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithRootViewController:(UIViewController *)rootViewController {
	if (self = [super initWithRootViewController:rootViewController]) {
		if ([rootViewController isKindOfClass:[MenuViewController class]]) {
			self.menuViewController = rootViewController;
		}
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showUsers {
	if (usersViewController == nil) {
		self.usersViewController = [[UsersViewController alloc] initWithNibName:@"UsersViewController" bundle:nil];
	}
	[self pushViewController:usersViewController animated:YES];
}

- (void)showNewMeetingLocation {
	if (newMeetingLocationController == nil) {
		self.newMeetingLocationController = [[NewMeetingLocationController alloc] initWithNibName:@"NewMeetingLocationController" bundle:nil];
	}
	[self pushViewController:newMeetingLocationController animated:YES];
}

- (void)showNewMeetingDateAndTime {
	if (newMeetingDateAndTimeController == nil) {
		self.newMeetingDateAndTimeController = [[NewMeetingDateAndTimeController alloc] initWithNibName:@"NewMeetingDateAndTimeController" bundle:nil];
	}
	[self pushViewController:newMeetingDateAndTimeController animated:YES];
}

- (void)showNewMeetingUsers {
	if (newMeetingUsersController == nil) {
		self.newMeetingUsersController = [[NewMeetingUsersController alloc] initWithNibName:@"NewMeetingUsersController" bundle:nil];
	}
	[self pushViewController:newMeetingUsersController animated:YES];
}

- (void)showSearchUsers {
	if (searchUsersViewController == nil) {
		self.searchUsersViewController = [[SearchUsersViewController alloc] initWithNibName:@"SearchUsersViewController" bundle:nil];
	}
	[self pushViewController:searchUsersViewController animated:YES];
}

- (void)showUserRequests {
	if (userRequestsViewController == nil) {
		self.userRequestsViewController = [[UserRequestsViewController alloc] initWithNibName:@"UserRequestsViewController" bundle:nil];
	}
	[self pushViewController:userRequestsViewController animated:YES];
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
	[usersViewController release];
	[newMeetingLocationController release];
	[newMeetingDateAndTimeController release];
	[newMeetingUsersController release];
	[searchUsersViewController release];
	[userRequestsViewController release];
	
    [super dealloc];
}

@end

