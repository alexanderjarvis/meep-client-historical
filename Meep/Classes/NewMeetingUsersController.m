//
//  NewMeetingUsersController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMeetingUsersController.h"
#import "MeepAppDelegate.h"
#import "ConfigManager.h"

@implementation NewMeetingUsersController

@synthesize userManager;
@synthesize currentUser;
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
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// Get the current user
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

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
	[currentUser release];
	[tableKeys release];
	[tableDictionary release];
    [super dealloc];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(User *)user {
	self.currentUser = user;
	
	// TODO: move to utility method
	// Compile user dictionary (for index)
	NSArray *connectedUsers = [currentUser connections];
	
	NSMutableDictionary *connectedUsersDictionary = [NSMutableDictionary dictionaryWithCapacity:[connectedUsers count]];
	for (User *connectedUser in connectedUsers) {
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

- (void)getUserFailedWithError:(NSError *)error {
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
}


@end

