//
//  UsersViewController.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "UsersViewController.h"
#import "MeepAppDelegate.h"
#import "ConfigManager.h"
#import "AlertView.h"
#import "UserDetailViewController.h"

@implementation UsersViewController

@synthesize usersRequestManager;
@synthesize tableKeys;
@synthesize tableDictionary;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Friends";
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	usersRequestManager = [[UsersRequestManager alloc] initWithAccessToken:configManager.accessToken];
	[usersRequestManager setDelegate:self];
	
	// Update table with users that have already been fetched.
	[self updateTableWithUsers:[[meepAppDelegate currentUser] connections]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// Get the users
	[usersRequestManager getUsers];
}

- (void)updateTableWithUsers:(NSArray *)users {
	
	NSMutableDictionary *connectedUsersDictionary = [NSMutableDictionary dictionaryWithCapacity:[users count]];
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:1];
	for (UserSummaryDTO *connectedUser in users) {
		if ([connectedUser.firstName length] > 0) {
			NSString *key = [[connectedUser.firstName substringToIndex:1] uppercaseString];
            [keys addObject:key];
			NSArray *usersInSection = [connectedUsersDictionary objectForKey:key];
			if (usersInSection == nil) {
				[connectedUsersDictionary setObject:[NSArray arrayWithObject:connectedUser] forKey:key];
			} else {
				NSMutableArray *mutableUsersInSection = [NSMutableArray arrayWithArray:usersInSection];
				[mutableUsersInSection addObject:connectedUser];
				[connectedUsersDictionary setObject:[NSArray arrayWithArray:mutableUsersInSection] forKey:key];
			}
		}
	}
	
	self.tableDictionary = [NSDictionary dictionaryWithDictionary:connectedUsersDictionary];
	self.tableKeys = [keys copy];
	
	[[super tableView] reloadData];
}

#pragma mark -
#pragma mark private

- (UserDTO *)userForIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [tableKeys objectAtIndex:[indexPath section]];
	NSArray *arrayOfUsers = [tableDictionary objectForKey:key];
	UserDTO *user = [arrayOfUsers objectAtIndex:[indexPath row]];
    return user;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [tableKeys count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSArray *usersInSection = [tableDictionary objectForKey:[tableKeys objectAtIndex:section]];
    return [usersInSection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [tableKeys objectAtIndex:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
	UserDTO *user = [self userForIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
	[userDetailViewController setUser:[self userForIndexPath:indexPath]];
	[self.navigationController pushViewController:userDetailViewController animated:YES];
	[userDetailViewController release];
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
	[usersRequestManager release];
	[tableKeys release];
	[tableDictionary release];
    [super dealloc];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUsersSuccessful:(NSArray *)users {
	
	// Only update the table if the response is new
	if ([usersRequestManager isResponseNew]) {
        [[[MeepAppDelegate sharedAppDelegate] currentUser] setConnections:users];
		[self updateTableWithUsers:users];
	}
}

- (void)getUsersFailedWithError:(NSError *)error {
}

- (void)getUsersFailedWithNetworkError:(NSError *)error {
    [AlertView showNetworkAlert:error];
}


@end

