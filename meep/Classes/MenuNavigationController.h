//
//  MenuNavigationController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"
#import "NewMeetingLocationController.h"

@interface MenuNavigationController : UINavigationController {
	
	MenuViewController *menuViewController;
	NewMeetingLocationController *newMeetingLocationController;

}

@property(nonatomic, retain) MenuViewController *menuViewController;
@property(nonatomic, retain) NewMeetingLocationController *newMeetingLocationController;

- (void)showNewMeeting;

@end
