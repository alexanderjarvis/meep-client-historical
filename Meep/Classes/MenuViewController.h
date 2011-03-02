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

#define MeetingsURL @"mp://meetings"
#define NewMeetingURL @"mp://newmeeting"
#define MeetingRequestsURL @"mp://meetingrequests"
#define SearchUsersURL @"mp://searchusers"
#define UserRequestsURL @"mp://userrequests"
#define UsersURL @"mp://users"
#define MyDetailsURL @"mp://mydetails"

@interface MenuViewController : TTViewController <TTLauncherViewDelegate, UIAlertViewDelegate> {
	
	TTLauncherView *launcherView;
	
	TTLauncherItem *meetingsItem;
	TTLauncherItem *friendsItem;
	TTLauncherItem *newMeetingItem;
	TTLauncherItem *myDetailsItem;
	TTLauncherItem *searchPeopleItem;
	TTLauncherItem *friendRequestsItem;
	TTLauncherItem *meetingRequestsItem;
	
	UIBarButtonItem *logoutButton;
	UIAlertView *logoutAlertView;
	
	UserManager *userManager;

}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item;
- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher;
- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher;

- (void)logoutUserButtonPressed:(id)sender;
- (void)logout;
- (void)showWelcomeView;

- (void)newMeetingCreated;

@end
