//
//  UserDetailViewController.m
//  Meep
//
//  Created by Alex Jarvis on 03/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "UserDetailViewController.h"
#import "MeepAppDelegate.h"
#import "MeepStyleSheet.h"
#import "AlertView.h"

@interface UserDetailViewController (private) 

- (void)deleteUser;

@end

@implementation UserDetailViewController

@synthesize tableFooterButtonView;
@synthesize user;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *accessToken = [[meepAppDelegate configManager] accessToken];
	
	// Request Add User button
	[TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	
    // HUD
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    // Determine what behaviour this controller will use based on which view controllers are on
    // the navigation stack.
    NSArray *viewControllers = [self.navigationController viewControllers];
    NSObject *backViewController = [viewControllers objectAtIndex:[viewControllers count] - 2];
    
    BOOL buttonEnabled = YES;
    
    if ([backViewController isKindOfClass:[UsersViewController class]]) {
        
        hud.labelText = @"Removing friend...";
        deleteUserRequestManager = [[DeleteUserRequestManager alloc] initWithAccessToken:accessToken];
        deleteUserRequestManager.delegate = self;
        
        // Add remove friend button
        ttButton = [TTFixedWidthButton buttonWithStyle:@"redButton:" title:@"Remove Friend"];
        [ttButton addTarget:self action:@selector(deleteUserButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    } else if ([backViewController isKindOfClass:[SearchUsersViewController class]]) {
        
        hud.labelText = @"Sending request...";
        addUserRequestManager = [[AddUserRequestManager alloc] initWithAccessToken:accessToken];
        addUserRequestManager.delegate = self;
        
        // Add request to add as a friend button
        ttButton = [TTFixedWidthButton buttonWithStyle:@"embossedButton:" title:@"Add as a Friend"];
        [ttButton addTarget:self action:@selector(requestAddUserButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // If the User is the current User, or already a connection, then disable the request to add user button.
        UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
        
        // If the User is the current User
        if ([currentUser._id isEqual:user._id]) {
            buttonEnabled = NO;
        }
        
        // If the user is already connected
        for (UserSummaryDTO *userSummaryDTO in currentUser.connections) {
            if ([userSummaryDTO._id isEqual:user._id]) {
                buttonEnabled = NO;
            }
        }
        
        // If the user has sent a request to or has a request from.
        for (UserSummaryDTO *userSummaryDTO in currentUser.connectionRequestsTo) {
            if ([userSummaryDTO._id isEqual:user._id]) {
                buttonEnabled = NO;
            }
        }
        for (UserSummaryDTO *userSummaryDTO in currentUser.connectionRequestsFrom) {
            if ([userSummaryDTO._id isEqual:user._id]) {
                buttonEnabled = NO;
            }
        }
        
    } else if ([backViewController isKindOfClass:[UserRequestsViewController class]]) {
        //
    }
    
    ttButton.width = 140;
    ttButton.font = [UIFont boldSystemFontOfSize:14];
    [ttButton sizeToFit];
    [tableFooterButtonView addSubview:ttButton];
    [ttButton setEnabled:buttonEnabled];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UserDetailViewController

- (void)requestAddUserButtonPressed {
	[addUserRequestManager addUserRequest:user];
    [hud show:YES];
}

- (void)deleteUserButtonPressed {
    deleteUserAlertView = [[UIAlertView alloc]
                          initWithTitle:@"Remove Friend" 
                          message:@"Are you sure?"
                          delegate:self 
                          cancelButtonTitle:@"No" 
                          otherButtonTitles:@"Yes", nil];
	[deleteUserAlertView show];
	[deleteUserAlertView release];
}

- (void)deleteUser {
    NSLog(@"delete user");
    [deleteUserRequestManager deleteUser:user];
    [hud show:YES];
}

#pragma mark - Table view data source

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
	return @"Details";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)dealloc {
    [hud release];
	[tableFooterButtonView release];
	[addUserRequestManager release];
    [deleteUserRequestManager release];
	[user release];
    [super dealloc];
}

#pragma mark -
#pragma mark AddUserRequestManagerDelegate

- (void)addUserRequestSuccessful {
    [hud hide:NO];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Success"
						  message:@"A request to connect has been sent successfully."
						  delegate:self
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[ttButton setEnabled:NO];
    // Update local model
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    NSMutableArray *mutableConnectionRequestsTo = [currentUser.connectionRequestsTo mutableCopy];
    UserSummaryDTO *userSummary = [[UserSummaryDTO alloc] init];
    userSummary._id = user._id;
    userSummary.firstName = user.firstName;
    userSummary.lastName = user.lastName;
    [mutableConnectionRequestsTo addObject:userSummary];
    [userSummary release];
    currentUser.connectionRequestsTo = [mutableConnectionRequestsTo copy];
    [mutableConnectionRequestsTo release];
}

- (void)addUserRequestFailedWithError:(NSError *)error {
    [hud hide:NO];
    NSLog(@"error: %@", error);
}

- (void)addUserRequestFailedWithNetworkError:(NSError *)error {
    [hud hide:NO];
	[AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark DeleteUserRequestManagerDelegate

- (void)deleteUserSuccessful {
    [hud hide:YES];
    
	// Update local model
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    NSMutableArray *mutableConnections = [[currentUser connections] mutableCopy];
    [mutableConnections removeObject:user];
    [currentUser setConnections:[mutableConnections copy]];
    [mutableConnections release];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteUserFailedWithError:(NSError *)error {
    [hud hide:YES];
    NSLog(@"error: %@", error);
}

- (void)deleteUserFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:deleteUserAlertView]) {
		switch (buttonIndex) {
			case 0:
				// Cancel
				break;
			case 1:
				// Logout
				[self deleteUser];
				break;
			default:
				break;
		}
	}
}

@end
