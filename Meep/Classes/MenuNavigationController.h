//
//  MenuNavigationController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserManager.h"
#import "LogoutManager.h"
#import "MenuViewController.h"
#import "MeetingsViewController.h"
#import "MeetingDetailViewController.h"
#import "UsersViewController.h"
#import "NewMeetingLocationController.h"
#import "NewMeetingDateAndTimeController.h"
#import "NewMeetingUsersController.h"
#import "SearchUsersViewController.h"
#import "UserRequestsViewController.h"
#import "LiveMapViewController.h"

@interface MenuNavigationController : UINavigationController <UserManagerDelegate, LogoutManagerDelegate> {
    
    UserManager *userManager;
    LogoutManager *logoutManager;
	
	MenuViewController *menuViewController;
	
	MeetingsViewController *meetingsViewController;
    MeetingDetailViewController *meetingDetailViewController;
	
	UsersViewController *usersViewController;
	
	NewMeetingLocationController *newMeetingLocationController;
	NewMeetingDateAndTimeController *newMeetingDateAndTimeController;
	NewMeetingUsersController *newMeetingUsersController;
	
	SearchUsersViewController *searchUsersViewController;
	UserRequestsViewController *userRequestsViewController;
    
    LiveMapViewController *liveMapViewController;
    UILocalNotification *liveMapNotificationWaitingForCurrentUser;
}

- (void)logout;
- (void)newMeetingCreated;

- (void)showMeetingsViewAnimated:(BOOL)animated;
- (void)showMeetingDetailView:(MeetingDTO *)meeting animated:(BOOL)animated;
- (void)showUsersViewAnimated:(BOOL)animated;
- (void)showNewMeetingLocationAnimated:(BOOL)animated;
- (void)showNewMeetingDateAndTimeAnimated:(BOOL)animated;
- (void)showNewMeetingUsersAnimated:(BOOL)animated;
- (void)showSearchUsersViewAnimated:(BOOL)animated;
- (void)showUserRequestsViewAnimated:(BOOL)animated;
- (void)showLiveMapViewAnimated:(BOOL)animated;
- (void)showLiveMapViewWith:(MeetingDTO *)meeting animated:(BOOL)animated;
- (void)showLiveMapFromLocalNotification:(UILocalNotification *)localNotification;

@end
