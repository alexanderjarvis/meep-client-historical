//
//  MenuNavigationController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuNavigationController.h"

#import "MeepAppDelegate.h"
#import "AlertView.h"

@interface MenuNavigationController (private)

- (void)applicationDidBecomeActive:(id)sender;
- (void)getCurrentUser;
- (void)showWelcomeView;

@end

@implementation MenuNavigationController

#pragma mark -
#pragma mark View lifecycle

/*
 * Default behaviour overriden so that a reference to the rootViewController can be stored locally.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
	if (self) {
		if ([rootViewController isKindOfClass:[MenuViewController class]]) {
			menuViewController = [(MenuViewController *)rootViewController retain];
		}
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Request Managers
    ConfigManager *configManager = [[MeepAppDelegate sharedAppDelegate] configManager];
    userManager = [[UserManager alloc] initWithAccessToken:configManager.accessToken];
    [userManager setDelegate:self];
    logoutManager = [[LogoutManager alloc] initWithAccessToken:configManager.accessToken];
    [logoutManager setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self getCurrentUser];
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
    [logoutManager release];
	[menuViewController release];
	[meetingsViewController release];
	[usersViewController release];
	[newMeetingLocationController release];
	[newMeetingDateAndTimeController release];
	[newMeetingUsersController release];
	[searchUsersViewController release];
	[userRequestsViewController release];
    [liveMapViewController release];
    [super dealloc];
}

#pragma mark - 
#pragma mark private
- (void)applicationDidBecomeActive:(id)sender {
    [self getCurrentUser];
}

/*
 * Gets the current user
 */
- (void)getCurrentUser {
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
	[userManager getUser:configManager.email];
}

- (void)showWelcomeView {
    [[MeepAppDelegate sharedAppDelegate] showWelcomeView];
}

#pragma mark -
#pragma mark MenuNavigationController

- (void)logout {
    [logoutManager logoutUser];
}

/*
 * To be called just after a meeting is successfully created in order to reset the meeting
 * creation views by releasing them.
 */
- (void)newMeetingCreated {
	[self popToRootViewControllerAnimated:YES];
	[newMeetingUsersController release];
	newMeetingUsersController = nil;
	[newMeetingDateAndTimeController release];
	newMeetingDateAndTimeController = nil;
	[newMeetingLocationController release];
	newMeetingLocationController = nil;
	[menuViewController newMeetingCreated];
}

- (void)showMeetingsViewAnimated:(BOOL)animated {
	if (meetingsViewController == nil) {
		meetingsViewController = [[MeetingsViewController alloc] initWithNibName:@"MeetingsViewController" bundle:nil];
	}
	[self pushViewController:meetingsViewController animated:animated];
}

- (void)showMeetingDetailView:(MeetingDTO *)meeting animated:(BOOL)animated {
    if (meetingDetailViewController == nil) {
        meetingDetailViewController = [[MeetingDetailViewController alloc] initWithNibName:@"MeetingDetailViewController" bundle:nil];
    }
    meetingDetailViewController.thisMeeting = meeting;
    [self pushViewController:meetingDetailViewController animated:animated];
}

- (void)showUsersViewAnimated:(BOOL)animated {
	if (usersViewController == nil) {
		usersViewController = [[UsersViewController alloc] initWithNibName:@"UsersViewController" bundle:nil];
	}
	[self pushViewController:usersViewController animated:animated];
}

- (void)showNewMeetingLocationAnimated:(BOOL)animated {
	if (newMeetingLocationController == nil) {
		newMeetingLocationController = [[NewMeetingLocationController alloc] initWithNibName:@"NewMeetingLocationController" bundle:nil];
	}
	[self pushViewController:newMeetingLocationController animated:animated];
}

- (void)showNewMeetingDateAndTimeAnimated:(BOOL)animated {
	if (newMeetingDateAndTimeController == nil) {
		newMeetingDateAndTimeController = [[NewMeetingDateAndTimeController alloc] initWithNibName:@"NewMeetingDateAndTimeController" bundle:nil];
	}
	[self pushViewController:newMeetingDateAndTimeController animated:animated];
}

- (void)showNewMeetingUsersAnimated:(BOOL)animated {
	if (newMeetingUsersController == nil) {
		newMeetingUsersController = [[NewMeetingUsersController alloc] initWithNibName:@"NewMeetingUsersController" bundle:nil];
	}
	[self pushViewController:newMeetingUsersController animated:animated];
}

- (void)showSearchUsersViewAnimated:(BOOL)animated; {
	if (searchUsersViewController == nil) {
		searchUsersViewController = [[SearchUsersViewController alloc] initWithNibName:@"SearchUsersViewController" bundle:nil];
	}
	[self pushViewController:searchUsersViewController animated:animated];
}

- (void)showUserRequestsViewAnimated:(BOOL)animated; {
	if (userRequestsViewController == nil) {
		userRequestsViewController = [[UserRequestsViewController alloc] initWithNibName:@"UserRequestsViewController" bundle:nil];
	}
	[self pushViewController:userRequestsViewController animated:animated];
}

- (void)showLiveMapViewAnimated:(BOOL)animated; {
	[self showLiveMapViewWith:nil animated:animated];
}

- (void)showLiveMapViewWith:(MeetingDTO *)meeting animated:(BOOL)animated {
    if (liveMapViewController == nil) {
		liveMapViewController = [[LiveMapViewController alloc] initWithNibName:@"LiveMapViewController" bundle:nil];
	}
    [liveMapViewController setCurrentMeeting:meeting];
	[self pushViewController:liveMapViewController animated:animated];
}

- (void)showLiveMapFromLocalNotification:(UILocalNotification *)localNotification {
       
    liveMapNotificationWaitingForCurrentUser = [localNotification retain];
    [self popToRootViewControllerAnimated:NO];
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    if (currentUser != nil) {
        [liveMapNotificationWaitingForCurrentUser release];
        liveMapNotificationWaitingForCurrentUser = nil;
        for (MeetingDTO *meeting in currentUser.meetingsRelated) {
            if ([meeting._id isEqualToNumber:[localNotification.userInfo valueForKey:kMeetingIdKey]]) {
                
                [self showMeetingsViewAnimated:NO];
                [self showMeetingDetailView:meeting animated:NO];
                [self showLiveMapViewWith:meeting animated:YES];
                break;
            }
        }
    } else {
        // show loading hud?
        // or always show loading hud when app is launched
    }
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(UserDTO *)user {
	NSLog(@"Get user successful");
	[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
	menuViewController.friendRequestsItem.badgeNumber = [[user connectionRequestsFrom] count];
    [LocalNotificationManager checkAndUpdateLocalNotificationsForUser:user];
    
    if (liveMapNotificationWaitingForCurrentUser != nil) {
        [self showLiveMapFromLocalNotification:liveMapNotificationWaitingForCurrentUser];
    }
}

- (void)getUserFailedWithError:(NSError *)error {
	[self showWelcomeView];
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
	[AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark LogoutManagerDelegate

- (void)logoutUserSuccessful {
	[self showWelcomeView];
}

- (void)logoutUserFailedWithError:(NSError *)error {
	[self showWelcomeView];
}

- (void)logoutUserFailedWithNetworkError:(NSError *)error {
	[AlertView showNetworkAlert:error];
}

@end

