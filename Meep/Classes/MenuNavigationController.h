//
//  MenuNavigationController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
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
#import "MyDetailsViewController.h"

@interface MenuNavigationController : UINavigationController <UserManagerDelegate, LogoutManagerDelegate, UIAlertViewDelegate> {
    
    MBProgressHUD *hud;
    NSDate *timeOfLastUserUpdate;
    BOOL userManagerRequestLock;
    UIAlertView *userManagerAlertView;
    UserManager *userManager;
    UIAlertView *logoutAlertView;
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
    
    MyDetailsViewController *myDetailsViewController;
}

- (void)logout:(BOOL)retry;
- (void)newMeetingCreated;
- (void)updateCurrentUser;

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
- (void)showMyDetailsViewAnimated:(BOOL)animated;

@end
