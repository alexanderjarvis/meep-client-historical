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
@synthesize newMeetingLocationController;
@synthesize newMeetingDateAndTimeController;
@synthesize newMeetingPeopleController;
@synthesize searchUsersViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {

	// Always load the root view controller
	self.menuViewController = [[MenuViewController alloc] init];
	[self pushViewController:menuViewController animated:NO];
	
    [super viewDidLoad];
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

- (void)showNewMeetingPeople {
	if (newMeetingPeopleController == nil) {
		self.newMeetingPeopleController = [[NewMeetingPeopleController alloc] initWithNibName:@"NewMeetingPeopleController" bundle:nil];
	}
	
	[self pushViewController:newMeetingPeopleController animated:YES];
}

- (void)showSearchUsers {
	if (searchUsersViewController == nil) {
		self.searchUsersViewController = [[SearchUsersViewController alloc] initWithNibName:@"SearchUsersViewController" bundle:nil];
	}
	
	[self pushViewController:searchUsersViewController animated:YES];
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
	[newMeetingLocationController release];
	[newMeetingDateAndTimeController release];
	[newMeetingPeopleController release];
	[searchUsersViewController release];
	
    [super dealloc];
}


@end

