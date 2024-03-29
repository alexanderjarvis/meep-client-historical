//
//  MenuViewController.h
//  meep
//
//  Created by Alex Jarvis on 16/10/2010.
//  Copyright 2010 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

#define MeetingsURL @"mp://meetings"
#define NewMeetingURL @"mp://newmeeting"
#define SearchUsersURL @"mp://searchusers"
#define UserRequestsURL @"mp://userrequests"
#define UsersURL @"mp://users"
#define MyDetailsURL @"mp://mydetails"
#define LiveMapURL @"mp://livemap"

@class MenuNavigationController;

@interface MenuViewController : TTViewController <TTLauncherViewDelegate, UIAlertViewDelegate> {
    
    MenuNavigationController *menuNavigationController;
	
	TTLauncherView *launcherView;
	
	TTLauncherItem *meetingsItem;
	TTLauncherItem *friendsItem;
	TTLauncherItem *newMeetingItem;
	TTLauncherItem *myDetailsItem;
	TTLauncherItem *searchPeopleItem;
	TTLauncherItem *friendRequestsItem;
    TTLauncherItem *liveMapItem;
	
	UIBarButtonItem *logoutButton;
	UIAlertView *logoutAlertView;
	
}

@property (nonatomic, assign) MenuNavigationController *menuNavigationController;
@property (nonatomic, retain) TTLauncherItem *friendRequestsItem;

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item;
- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher;
- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher;

- (void)logoutUserButtonPressed:(id)sender;
- (void)updateBadgeCounts;

@end
