//
//  UsersViewController.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UsersViewController.h"
#import "MeepAppDelegate.h"
#import "ConfigManager.h"

@implementation UsersViewController

@synthesize userManager;
@synthesize tableKeys;
@synthesize tableDictionary;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Friends";
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	userManager = [[UserManager alloc] initWithAccessToken:configManager.access_token];
	[userManager setDelegate:self];
	
	// Update table with users that have already been fetched.
	[self updateTableWithUser:[meepAppDelegate currentUser]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// Get the current user
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
}

- (void)updateTableWithUser:(User *)user {
	NSArray *connectedUsers = [user connections];
	
	NSMutableDictionary *connectedUsersDictionary = [NSMutableDictionary dictionaryWithCapacity:[connectedUsers count]];
	for (UserSummaryDTO *connectedUser in connectedUsers) {
		if ([connectedUser.firstName length] > 0) {
			NSString *key = [[connectedUser.firstName substringToIndex:1] uppercaseString];
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
	self.tableKeys = [tableDictionary allKeys];
	
	[[super tableView] reloadData];
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
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *key = [tableKeys objectAtIndex:section];
	NSArray *arrayOfUsers = [tableDictionary objectForKey:key];
	User *user = [arrayOfUsers objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
	[userManager release];
	[tableKeys release];
	[tableDictionary release];
    [super dealloc];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(User *)user {
	
	// Only update the table if the response is new
	if (![userManager isResponseSameAsPreviousRequest]) {
		[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
		[self updateTableWithUser:user];
	}
}

- (void)getUserFailedWithError:(NSError *)error {
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
}


@end

