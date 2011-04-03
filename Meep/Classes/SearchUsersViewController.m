//
//  SearchUsersViewController.m
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchUsersViewController.h"
#import "MeepAppDelegate.h"
#import "AlertView.h"
#import "SearchUsersManager.h"
#import "UserDTO.h"
#import "UserDetailViewController.h"

@implementation SearchUsersViewController

@synthesize searchUsersManager;
@synthesize searchDisplayController;
@synthesize users;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.title = @"Search People";
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *accessToken = [[meepAppDelegate configManager] accessToken];
	searchUsersManager = [[SearchUsersManager alloc] initWithAccessToken: accessToken];
	[searchUsersManager setDelegate: self];
	
	searchDisplayController.searchResultsDataSource = self;
	searchDisplayController.searchResultsDelegate = self;
	
    [super viewDidLoad];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [users count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSLog(@"reloading data");
	if ([users count] > 0) {
		UserDTO *user = [users objectAtIndex:row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
	[userDetailViewController setUser:[users objectAtIndex:[indexPath row]]];
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
	[searchUsersManager release];
	[searchDisplayController release];
	[users release];
    [super dealloc];
}

#pragma mark -
#pragma mark UISearchBarDelegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if ([searchText length] > 2) {
		[searchUsersManager searchUsers:searchText];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {	
	[searchUsersManager searchUsers:[searchBar text]];
}

#pragma mark -
#pragma mark SearchUsersManagerDelegate methods

- (void)searchUsersSuccessful:(NSArray *)usersFound {
	self.users = usersFound;
	[[super tableView] reloadData];
	[[searchDisplayController searchResultsTableView] reloadData];
}

- (void)searchUsersNotFound {
	self.users = [NSArray array];
	[[super tableView] reloadData];
	[[searchDisplayController searchResultsTableView] reloadData];
}

- (void)searchUsersFailedWithError:(NSError *)error {
}

- (void)searchUsersFailedWithNetworkError:(NSError *)error {
	[AlertView showNetworkAlert:error];
}

@end

