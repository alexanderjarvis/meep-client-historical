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
#import "MeepStyleSheet.h"
#import "NewMeetingBuilder.h"
#import "AlertView.h"


@implementation NewMeetingUsersController

@synthesize createMeetingButton;
@synthesize userManager;
@synthesize createMeetingRequestManager;
@synthesize tableKeys;
@synthesize tableDictionary;
@synthesize selectedUsers;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"Friends";
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	userManager = [[UserManager alloc] initWithAccessToken:configManager.access_token];
	[userManager setDelegate:self];
	
	createMeetingRequestManager = [[CreateMeetingRequestManager alloc] initWithAccessToken:configManager.access_token];
	[createMeetingRequestManager setDelegate:self];
	
	selectedUsers = [[NSMutableArray alloc] initWithCapacity:1];
	
	// Create meeting button
	[TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	TTButton *button = [TTButton buttonWithStyle:@"embossedButton:" title:@"Create Meeting"];
	button.font = [UIFont boldSystemFontOfSize:14];
	[button sizeToFit];
	[button addTarget:self action:@selector(createMeetingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[createMeetingButton addSubview: button];
	
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

- (void)createMeetingButtonPressed {
	if ([selectedUsers count] > 0) {
		MeetingDTO *meetingDTO = [[NewMeetingBuilder sharedNewMeetingBuilder] meetingDTO];
		
		// Convert array of User to array of UserSummaryDTO
		NSMutableArray *attendees = [NSMutableArray arrayWithCapacity:[selectedUsers count]];
		for (User *user in selectedUsers) {
			UserSummaryDTO *userSummaryDTO = [[UserSummaryDTO alloc] init];
			userSummaryDTO._id = user._id;
			[attendees addObject:userSummaryDTO];
		}
		meetingDTO.attendees = attendees;
		
		[createMeetingRequestManager createMeeting:meetingDTO];
	} else {
		[AlertView showSimpleAlertMessage:@"You must select at least one friend to create a meeting." withTitle:@""];
	}
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
	
	[selectedUsers removeAllObjects];
	
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
	if ([selectedUsers containsObject:user]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSString *key = [tableKeys objectAtIndex:section];
	NSArray *arrayOfUsers = [tableDictionary objectForKey:key];
	User *user = [arrayOfUsers objectAtIndex:row];
	if ([selectedUsers containsObject:user]) {
		[selectedUsers removeObject:user];
	} else {
		[selectedUsers addObject:user];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
	[createMeetingButton release];
	[userManager release];
	[createMeetingRequestManager release];
	[tableKeys release];
	[tableDictionary release];
	[selectedUsers release];
    [super dealloc];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(User *)user {
	
	// Only update the table if the response is new
	if ([userManager isResponseNew]) {
		[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
		[self updateTableWithUser:user];
	}
}

- (void)getUserFailedWithError:(NSError *)error {
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
}

#pragma mark -
#pragma mark CreateMeetingRequestManagerDelegate
- (void)createMeetingSuccessful {
	[AlertView showSimpleAlertMessage:@"Meeting created successfully!" 
							withTitle:@"" 
						  andDelegate:self];
}

- (void)createMeetingFailedWithError:(NSError *)error {
}

- (void)createMeetingFailedWithNetworkError:(NSError *)error {
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[[[MeepAppDelegate sharedAppDelegate] menuNavigationController] newMeetingCreated];
}


@end

