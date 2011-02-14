//
//  SearchUsersViewController.m
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchUsersViewController.h"
#import "MeepAppDelegate.h"
#import "SearchUsersManager.h"
#import "User.h"
#import "SearchUsersDetailViewController.h"

@implementation SearchUsersViewController

@synthesize searchDisplayController;
@synthesize users;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.title = @"Search People";
	
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
		User *user = [users objectAtIndex:row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	SearchUsersDetailViewController *searchUsersDetailViewController = [[SearchUsersDetailViewController alloc] initWithNibName:@"SearchUsersDetailViewController" bundle:nil];
	[searchUsersDetailViewController setUser:[users objectAtIndex:[indexPath row]]];
	[self.navigationController pushViewController:searchUsersDetailViewController animated:YES];
	[searchUsersDetailViewController release];
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
	[searchDisplayController release];
	[users release];
    [super dealloc];
}

#pragma mark -
#pragma mark UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"SearchBar text: %@", [searchBar text]);
	MeepAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSString *accessToken = [[appDelegate configManager] access_token];
	SearchUsersManager *searchUsersManager = [[SearchUsersManager alloc] initWithAccessToken: accessToken];
	[searchUsersManager setDelegate: self];
	[searchUsersManager searchUsers:[searchBar text]];
}

#pragma mark -
#pragma mark SearchUsersManagerDelegate methods
- (void)searchUsersSuccessful:(NSArray *)users {
	NSLog(@"searchUsersSuccessful");
	self.users = users;
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
}



@end

