//
//  UserRequestsViewController.m
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserRequestsViewController.h"

#import "MeepAppDelegate.h"
#import "ConfigManager.h"

#import "UserRequestsCustomCell.h"

@implementation UserRequestsViewController

@synthesize userManager;
@synthesize acceptUserRequestManager;
@synthesize declineUserRequestManager;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.title = @"Friend Requests";
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	userManager = [[UserManager alloc] initWithAccessToken:configManager.access_token];
	[userManager setDelegate:self];
	
	acceptUserRequestManager = [[AcceptUserRequestManager alloc] initWithAccessToken:configManager.access_token];
	[acceptUserRequestManager setDelegate:self];
	
	declineUserRequestManager = [[DeclineUserRequestManager alloc] initWithAccessToken:configManager.access_token];
	[declineUserRequestManager setDelegate:self];
	
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Get the current user
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
}

-(void)acceptUserAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	User *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
	[acceptUserRequestManager acceptUser:user];
}

-(void)declineUserAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	User *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
	[declineUserRequestManager declineUser:user];
}

-(void)removeRowThatHasUser:(User *)user {

	NSUInteger row = 0;
	User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	// Although the IndexPath could be passed to the Request manager, it is not relevant
	// aside from returning the value back to this table view controller
	// and so the row is calculated from the user object instead.
	for (row = 0; row < [[currentUser connectionRequestsFrom] count]; row++) {
		User *requestFromUser = [[currentUser connectionRequestsFrom] objectAtIndex:row];
		
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
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
		cell = [[UserRequestsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
	}
    
    // Configure the cell...
	cell.userRequestsViewController = self;
	cell.indexPath = indexPath;
	// Name
	User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	User *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
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
	[userManager release];
	[acceptUserRequestManager release];
	[declineUserRequestManager release];
    [super dealloc];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(User *)user {
	
	// Only update the table if the response is new
	if ([userManager isResponseNew]) {
		[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
		[[super tableView] reloadData];
	}
}

- (void)getUserFailedWithError:(NSError *)error {
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
}

#pragma mark -
#pragma mark AcceptUserRequestManagerDelegate

- (void)acceptUserSuccessful:(User *)user {
	NSLog(@"accept user successful");
	
	[self removeRowThatHasUser:user];
}

- (void)acceptUserFailedWithError:(NSError *)error {
}

- (void)acceptUserFailedWithNetworkError:(NSError *)error {
}

#pragma mark -
#pragma mark DeclineUserRequestManagerDelegate

- (void)declineUserSuccessful:(User *)user {
	NSLog(@"decline user successful");
	
	[self removeRowThatHasUser:user];
}

- (void)declineUserFailedWithError:(NSError *)error {
}

- (void)declineUserFailedWithNetworkError:(NSError *)error {
}


@end