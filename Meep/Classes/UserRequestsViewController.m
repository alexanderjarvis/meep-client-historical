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
@synthesize currentUser;
@synthesize acceptUserRequestManager;

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
	
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	// Get the current user
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
	
    [super viewWillAppear:animated];
}

-(void)acceptUserAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	
	User *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
	[acceptUserRequestManager acceptUser:user];
}
-(void)declineUserAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
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
	User *user = [currentUser.connectionRequestsFrom objectAtIndex:row];
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
	[currentUser release];
	[acceptUserRequestManager release];
    [super dealloc];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(User *)user {
	NSLog(@"Get user successful");
	self.currentUser = user;
	[[super tableView] reloadData];
}

- (void)getUserFailedWithError:(NSError *)error {
	//[self showWelcomeView];
	
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
	//[self showWelcomeView];
}

#pragma mark -
#pragma mark AcceptUserRequestManagerDelegate

- (void)acceptUserSuccessful {
	NSLog(@"accept user successful");
	//TODO: remove that row
}

- (void)acceptUserFailedWithError:(NSError *)error {

}

- (void)acceptUserFailedWithNetworkError:(NSError *)error {

}


@end