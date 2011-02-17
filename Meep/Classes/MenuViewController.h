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
#import "NewMeetingLocationController.h"

#define NewMeetingURL @"mp://newmeeting"
#define SearchUsersURL @"mp://searchusers"
#define ConnectionRequestsURL @"mp://connectionrequests"

@interface MenuViewController : TTViewController <TTLauncherViewDelegate> {
	
	UserManager *userManager;
	User *currentUser;
	
	TTLauncherView *launcherView;
	
	TTLauncherItem *connectionRequestsItem;
	
	NewMeetingLocationController *newMeetingLocationController;

}

@property (nonatomic, retain) User *currentUser;

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item;
- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher;
- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher;

- (void)logoutUserButton:(id)sender;

@end
