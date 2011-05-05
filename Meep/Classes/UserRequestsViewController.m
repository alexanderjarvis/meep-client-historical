//
//  UserRequestsViewController.m
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "UserRequestsViewController.h"

#import "MeepAppDelegate.h"
#import "ConfigManager.h"
#import "UserRequestsCustomCell.h"
#import "AlertView.h"

@interface UserRequestsViewController (private)

- (void)removeRowThatHasUser:(UserSummaryDTO *)user;
- (void)removeConnectionFromLocalModel:(UserSummaryDTO *)user;
- (void)popViewIfNoMoreRequests;
 
@end

@implementation UserRequestsViewController

@synthesize userManager;
@synthesize acceptUserRequestManager;
@synthesize declineUserRequestManager;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = @"Friend Requests";
    
	// Request Managers
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	userManager = [[UserManager alloc] initWithAccessToken:configManager.accessToken];
	[userManager setDelegate:self];
	
	acceptUserRequestManager = [[AcceptUserRequestManager alloc] initWithAccessToken:configManager.accessToken];
	[acceptUserRequestManager setDelegate:self];
	
	declineUserRequestManager = [[DeclineUserRequestManager alloc] initWithAccessToken:configManager.accessToken];
	[declineUserRequestManager setDelegate:self];
	
    // HUD
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"Updating...";
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Get the current user
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
}

- (void)acceptUserAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	UserSummaryDTO *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
	[acceptUserRequestManager acceptUser:user];
    [hud show:YES];
}

- (void)declineUserAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	UserSummaryDTO *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
	[declineUserRequestManager declineUser:user];
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
	UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	if (currentUser.connectionRequestsFrom != nil) {
		return [currentUser.connectionRequestsFrom count];
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
    static NSString *CustomCellIdentifier = @"Cell";
	
	UserRequestsCustomCell *cell = (UserRequestsCustomCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	if (cell == nil) {
		cell = [[[UserRequestsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier] autorelease];
	}
    
    // Configure the cell...
	cell.userRequestsViewController = self;
	cell.indexPath = indexPath;
	// Name
	UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	UserDTO *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
	
    return cell;
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
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [hud release];
	[userManager release];
	[acceptUserRequestManager release];
	[declineUserRequestManager release];
    [super dealloc];
}

#pragma mark -
#pragma mark private

- (void)removeRowThatHasUser:(UserSummaryDTO *)user {
    
	NSUInteger row = 0;
	UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	// Although the IndexPath could be passed to the Request manager, it is not relevant
	// aside from returning the value back to this table view controller
	// and so the row is calculated from the user object instead.
	for (row = 0; row < [[currentUser connectionRequestsFrom] count]; row++) {
		UserDTO *requestFromUser = [[currentUser connectionRequestsFrom] objectAtIndex:row];
		
		if ([requestFromUser._id isEqualToNumber:user._id]) {
			NSMutableArray *arrayOfUsers = [NSMutableArray arrayWithArray:[currentUser connectionRequestsFrom]];
			[arrayOfUsers removeObjectAtIndex:row];
			[currentUser setConnectionRequestsFrom:[NSArray arrayWithArray:arrayOfUsers]];
			[[super tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] 
									 withRowAnimation:UITableViewRowAnimationFade];
			return;
		}
	}	
}

- (void)removeConnectionFromLocalModel:(UserSummaryDTO *)user {
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    NSMutableArray *mutableConnectionRequestsFrom = [currentUser.connectionRequestsFrom mutableCopy];
    [mutableConnectionRequestsFrom removeObject:user];
    currentUser.connectionRequestsFrom = [mutableConnectionRequestsFrom copy];
    [mutableConnectionRequestsFrom release];
}

- (void)popViewIfNoMoreRequests {
    // If there is no more connection requests to display
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    if ([currentUser.connectionRequestsFrom count] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(UserDTO *)user {
	
	[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
    [[super tableView] reloadData];
}

- (void)getUserFailedWithError:(NSError *)error {
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark AcceptUserRequestManagerDelegate

- (void)acceptUserSuccessful:(UserSummaryDTO *)user {
	[hud hide:YES];
	[self removeRowThatHasUser:user];
    [self removeConnectionFromLocalModel:user];
    [self popViewIfNoMoreRequests];
}

- (void)acceptUserFailedWithError:(NSError *)error {
    [hud hide:YES];
}

- (void)acceptUserFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark DeclineUserRequestManagerDelegate

- (void)declineUserSuccessful:(UserSummaryDTO *)user {
	[hud hide:YES];
	[self removeRowThatHasUser:user];
    [self removeConnectionFromLocalModel:user];
    [self popViewIfNoMoreRequests];
}

- (void)declineUserFailedWithError:(NSError *)error {
    [hud hide:YES];
}

- (void)declineUserFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
    [AlertView showNetworkAlert:error];
}


@end