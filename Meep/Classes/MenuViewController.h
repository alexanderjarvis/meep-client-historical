//
//  MenuViewController.h
//  meep
//
//  Created by Alex Jarvis on 16/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Three20/Three20.h>

#import "NewMeetingLocationController.h"

#define NewMeetingURL @"mp://newmeeting"

@interface MenuViewController : TTViewController <TTLauncherViewDelegate> {
	
	TTLauncherView *launcherView;
	
	NewMeetingLocationController *newMeetingLocationController;

}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item;
- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher;
- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher;

- (void)logoutUserButton:(id)sender;

@end
