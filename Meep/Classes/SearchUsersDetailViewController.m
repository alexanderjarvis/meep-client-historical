//
//  SearchUsersDetailViewController.m
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchUsersDetailViewController.h"
#import "MeepAppDelegate.h"
#import "MeepStyleSheet.h"
#import "AlertView.h"

@implementation SearchUsersDetailViewController

@synthesize requestAddUserButton;
@synthesize addUserRequestManager;
@synthesize user;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.title = @"Add Request";
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *accessToken = [[meepAppDelegate configManager] accessToken];
	addUserRequestManager = [[AddUserRequestManager alloc] initWithAccessToken:accessToken];
	[addUserRequestManager setDelegate:self];
	
	// Request Add User button
	[TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	TTButton *button = [TTButton buttonWithStyle:@"embossedButton:" title:@"Request to Add as a Friend"];
	button.font = [UIFont boldSystemFontOfSize:14];
	[button sizeToFit];
	[button addTarget:self action:@selector(requestAddUserButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[requestAddUserButton addSubview: button];
	tt_requestAddUserButton = button;
    
    // HUD
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"Sending request...";
	
    [super viewDidLoad];
}
		 
- (void)viewWillAppear:(BOOL)animated {
	
	// If the User is the current User, or already a connection, then disable the request to add user button.
	UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	
	// If the User is the current User
	if ([currentUser._id isEqual:user._id]) {
		[tt_requestAddUserButton setEnabled:NO];
		return;
	}
	
	// If the user is already connected
	for (UserSummaryDTO *userSummaryDTO in currentUser.connections) {
		if ([userSummaryDTO._id isEqual:user._id]) {
			[tt_requestAddUserButton setEnabled:NO];
			return;
		}
	}
	
	// If the user has sent a request to or has a request from.
	for (UserSummaryDTO *userSummaryDTO in currentUser.connectionRequestsTo) {
		if ([userSummaryDTO._id isEqual:user._id]) {
			[tt_requestAddUserButton setEnabled:NO];
			return;
		}
	}
	for (UserSummaryDTO *userSummaryDTO in currentUser.connectionRequestsFrom) {
		if ([userSummaryDTO._id isEqual:user._id]) {
			[tt_requestAddUserButton setEnabled:NO];
			return;
		}
	}

	[tt_requestAddUserButton setEnabled:YES];

}

- (void)requestAddUserButtonPressed {
	[addUserRequestManager addUserRequest:user];
    [hud show:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (row == 0) {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Details";
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [hud release];
	[requestAddUserButton release];
	[addUserRequestManager release];
	[user release];
    [super dealloc];
}

#pragma mark -
#pragma mark AddUserRequestManagerDelegate methods

- (void)addUserRequestSuccessful {
    [hud hide:NO];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Success"
						  message:@"A request to connect has been sent successfully."
						  delegate:self
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[tt_requestAddUserButton setEnabled:NO];
    // Update local model
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    NSMutableArray *mutableConnectionRequestsTo = [currentUser.connectionRequestsTo mutableCopy];
    UserSummaryDTO *userSummary = [[UserSummaryDTO alloc] init];
    userSummary._id = user._id;
    userSummary.firstName = user.firstName;
    userSummary.lastName = user.lastName;
    [mutableConnectionRequestsTo addObject:userSummary];
    [userSummary release];
    currentUser.connectionRequestsTo = [mutableConnectionRequestsTo copy];
}

- (void)addUserRequestFailedWithError:(NSError *)error {
    [hud hide:NO];
    NSLog(@"error: %@", error);
}

- (void)addUserRequestFailedWithNetworkError:(NSError *)error {
    [hud hide:NO];
	[AlertView showNetworkAlert:error];
}

@end

