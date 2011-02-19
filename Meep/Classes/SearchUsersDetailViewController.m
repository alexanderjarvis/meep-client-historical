//
//  SearchUsersDetailViewController.m
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchUsersDetailViewController.h"
#import "MeepAppDelegate.h"

@implementation SearchUsersDetailViewController

@synthesize addUserRequestManager;
@synthesize user;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.title = @"Add Request";
	
	MeepAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSString *accessToken = [[appDelegate configManager] access_token];
	addUserRequestManager = [[AddUserRequestManager alloc] initWithAccessToken:accessToken];
	[addUserRequestManager setDelegate:self];
	
    [super viewDidLoad];
}

- (IBAction)requestAddUser {
	NSLog(@"Request to Add user");
	[addUserRequestManager addUserRequest:user];
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
	if (section == 0) {
		return @"Details";
	}
	return nil;
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
	[addUserRequestManager release];
	[user release];
    [super dealloc];
}

#pragma mark -
#pragma mark AddUserRequestManagerDelegate methods

- (void)addUserRequestSuccessful {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Success"
						  message:@"A request to connect has been sent successfully."
						  delegate:self
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)addUserRequestFailedWithError:(NSError *)error {
}

- (void)addUserRequestFailedWithNetworkError:(NSError *)error {
}

@end

