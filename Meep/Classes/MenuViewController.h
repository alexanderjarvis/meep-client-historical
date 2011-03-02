//
//  MenuViewController.h
//  meep
//
//  Created by Alex Jarvis on 16/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

#import "UserManager.h"

#define NewMeetingURL @"mp://newmeeting"
#define SearchUsersURL @"mp://searchusers"
#define UserRequestsURL @"mp://userrequests"
#define UsersURL @"mp://users"

@interface MenuViewController : TTViewController <TTLauncherViewDelegate, UIAlertViewDelegate> {
	
	TTLauncherView *launcherView;
	TTLauncherItem *connectionRequestsItem;
	UIBarButtonItem *logoutButton;
	UIAlertView *logoutAlertView;
	
	UserManager *userManager;
	User *currentUser;

}

@property (nonatomic, retain) User *currentUser;

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item;
- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher;
- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher;

- (void)logoutUserButtonPressed:(id)sender;
- (void)logout;

@end
