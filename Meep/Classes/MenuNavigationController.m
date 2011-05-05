//
//  MenuNavigationController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "MenuNavigationController.h"

#import "MeepAppDelegate.h"
#import "AlertView.h"

@interface MenuNavigationController (private)

- (void)applicationDidBecomeActive:(id)sender;
- (void)getCurrentUserAndShowHUD:(BOOL)showHud animated:(BOOL)animated isRetry:(BOOL)retry;
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
            menuViewController.menuNavigationController = self;
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
    
    // Create HUD
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    // It is necessary to provide a lock for the UserManager requests as we don't want
    // two requests to fire at the same time. The use case for this is when the view loads into memory
    // but the application becomes active at the same time and a current user does not exist.
    userManagerRequestLock = NO;
    
    [self getCurrentUserAndShowHUD:YES animated:NO isRetry:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [timeOfLastUserUpdate release];
    [liveMapNotificationWaitingForCurrentUser release];
    [hud release];
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
    [myDetailsViewController release];
    [super dealloc];
}

#pragma mark - 
#pragma mark private

- (void)applicationDidBecomeActive:(id)sender {
    
    // If the current user has not yet been obtained, get it
    if ([[MeepAppDelegate sharedAppDelegate] currentUser] == nil) {
        
        [self getCurrentUserAndShowHUD:YES animated:NO isRetry:NO];
    
    // Or if the time of the last update was more than a minute ago
    } else if (timeOfLastUserUpdate != nil && [timeOfLastUserUpdate timeIntervalSinceNow] >= 60) {
        
        [self getCurrentUserAndShowHUD:YES animated:NO isRetry:NO];
    }
}

/*
 * Gets the current user and optionally shows the hud. The hud is only shown when getting the current
 * user is absolutely necessary e.g. after logging in or when the application becomes active.
 */
- (void)getCurrentUserAndShowHUD:(BOOL)showHud animated:(BOOL)animated isRetry:(BOOL)retry {
    if (!userManagerRequestLock) {
        userManagerRequestLock = YES;
        
        if (retry) {
            [userManager retryPreviousRequest];
        } else {
            ConfigManager *configManager = [[MeepAppDelegate sharedAppDelegate] configManager];
            [userManager getUser:configManager.email];
        }
        
        if (showHud) {
            hud.labelText = @"Loading...";
            [hud show:animated];
        }
    }
}

- (void)showWelcomeView {
    [[MeepAppDelegate sharedAppDelegate] showWelcomeView];
}

#pragma mark -
#pragma mark MenuNavigationController

/*
 * Logout the current user. If retry is YES then the request is retried e.g. on connection failure.
 */
- (void)logout:(BOOL)retry {
    if (retry) {
        [logoutManager retryPreviousRequest];
    } else {
        [logoutManager logoutUser];
    }
    hud.labelText = @"Logging out...";
    [hud show:YES];
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
}

- (void)updateCurrentUser {
    [self getCurrentUserAndShowHUD:NO animated:NO isRetry:NO];
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
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    
    if (currentUser != nil) {
        [liveMapNotificationWaitingForCurrentUser release];
        liveMapNotificationWaitingForCurrentUser = nil;
        for (MeetingDTO *meeting in currentUser.meetingsRelated) {
            if ([meeting._id isEqualToNumber:[localNotification.userInfo valueForKey:kMeetingIdKey]]) {
                [self popToRootViewControllerAnimated:NO];
                [self showMeetingsViewAnimated:NO];
                [self showMeetingDetailView:meeting animated:NO];
                [self showLiveMapViewWith:meeting animated:YES];
                break;
            }
        }
    } else {
        [self popToRootViewControllerAnimated:YES];
        [self getCurrentUserAndShowHUD:YES animated:YES isRetry:NO];
    }
}

- (void)showMyDetailsViewAnimated:(BOOL)animated {
    if (myDetailsViewController == nil) {
		myDetailsViewController = [[MyDetailsViewController alloc] initWithNibName:@"MyDetailsViewController" bundle:nil];
	}
	[self pushViewController:myDetailsViewController animated:animated];
}

#pragma mark -
#pragma mark UserManagerDelegate

- (void)getUserSuccessful:(UserDTO *)user {
	NSLog(@"Get user successful");
    userManagerRequestLock = NO;
    [hud hide:YES];
	[[MeepAppDelegate sharedAppDelegate] setCurrentUser:user];
    timeOfLastUserUpdate = [[NSDate alloc] init];
	menuViewController.friendRequestsItem.badgeNumber = [[user connectionRequestsFrom] count];
    [LocalNotificationManager checkAndUpdateLocalNotificationsForUser:user];
    
    if (liveMapNotificationWaitingForCurrentUser != nil) {
        [self showLiveMapFromLocalNotification:liveMapNotificationWaitingForCurrentUser];
    }
}

- (void)getUserFailedWithError:(NSError *)error {
    // No need to hide the hud and set the request lock as this view is released
	[self showWelcomeView];
}

- (void)getUserFailedWithNetworkError:(NSError *)error {
    userManagerRequestLock = NO;
    [hud hide:YES];
    userManagerAlertView = [AlertView showNetworkAlertWithForcedRetry:error delegate:self];
}

#pragma mark -
#pragma mark LogoutManagerDelegate

- (void)logoutUserSuccessful {
    // No need to hide the hud as this view is released
	[self showWelcomeView];
}

- (void)logoutUserFailedWithError:(NSError *)error {
    // No need to hide the hud as this view is released
	[self showWelcomeView];
}

- (void)logoutUserFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
    logoutAlertView = [AlertView showNetworkAlertWithRetry:error delegate:self];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView isEqual:userManagerAlertView]) {
        
        [self getCurrentUserAndShowHUD:YES animated:YES isRetry:YES];
        
    } else if ([alertView isEqual:logoutAlertView]) {
        switch (buttonIndex) {
            case 0:
                // Dismiss
                break;
            case 1:
                // Retry
                [self logout:YES];
                break;
        }
    }
    
}

@end

