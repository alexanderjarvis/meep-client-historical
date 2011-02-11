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
#import "NewMeetingDateAndTimeController.h"
#import "NewMeetingPeopleController.h"

@interface MenuNavigationController : UINavigationController {
	
	MenuViewController *menuViewController;
	
	NewMeetingLocationController *newMeetingLocationController;
	NewMeetingDateAndTimeController *newMeetingDateAndTimeController;
	NewMeetingPeopleController *newMeetingPeopleController;

}

@property(nonatomic, retain) MenuViewController *menuViewController;
@property(nonatomic, retain) NewMeetingLocationController *newMeetingLocationController;
@property(nonatomic, retain) NewMeetingDateAndTimeController *newMeetingDateAndTimeController;
@property(nonatomic, retain) NewMeetingPeopleController *newMeetingPeopleController;

- (void)showNewMeetingLocation;
- (void)showNewMeetingDateAndTime;
- (void)showNewMeetingPeople;

- (void)showNetworkAlert:(NSError *)error;

@end
