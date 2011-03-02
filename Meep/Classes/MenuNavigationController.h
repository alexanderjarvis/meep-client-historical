//
//  MenuNavigationController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UsersViewController.h"
#import "NewMeetingLocationController.h"
#import "NewMeetingDateAndTimeController.h"
#import "NewMeetingUsersController.h"
#import "SearchUsersViewController.h"
#import "UserRequestsViewController.h"

@interface MenuNavigationController : UINavigationController {
	
	UsersViewController *usersViewController;
	
	NewMeetingLocationController *newMeetingLocationController;
	NewMeetingDateAndTimeController *newMeetingDateAndTimeController;
	NewMeetingUsersController *newMeetingUsersController;
	
	SearchUsersViewController *searchUsersViewController;
	UserRequestsViewController *userRequestsViewController;

}

@property(nonatomic, retain) UsersViewController *usersViewController;
@property(nonatomic, retain) NewMeetingLocationController *newMeetingLocationController;
@property(nonatomic, retain) NewMeetingDateAndTimeController *newMeetingDateAndTimeController;
@property(nonatomic, retain) NewMeetingUsersController *newMeetingUsersController;
@property(nonatomic, retain) SearchUsersViewController *searchUsersViewController;
@property(nonatomic, retain) UserRequestsViewController *userRequestsViewController;

- (void)showUsers;

- (void)showNewMeetingLocation;
- (void)showNewMeetingDateAndTime;
- (void)showNewMeetingUsers;

- (void)showSearchUsers;
- (void)showUserRequests;

- (void)showNetworkAlert:(NSError *)error;

- (void)newMeetingCreated;

@end
