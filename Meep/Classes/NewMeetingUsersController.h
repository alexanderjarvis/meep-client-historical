//
//  NewMeetingUsersController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserManager.h"
#import "User.h"
#import "CreateMeetingRequestManager.h"


@interface NewMeetingUsersController : UITableViewController <CreateMeetingRequestManagerDelegate, UIAlertViewDelegate> {
	
	IBOutlet UIButton *createMeetingButton;
	
	UserManager *userManager;
	CreateMeetingRequestManager *createMeetingRequestManager;
	
	NSArray *tableKeys;
	NSDictionary *tableDictionary;
	NSMutableArray *selectedUsers;
	
}

@property(nonatomic, retain) UIButton *createMeetingButton;

@property(nonatomic, retain) UserManager *userManager;
@property(nonatomic, retain) CreateMeetingRequestManager *createMeetingRequestManager;

@property(nonatomic, retain) NSArray *tableKeys;
@property(nonatomic, retain) NSDictionary *tableDictionary;
@property(nonatomic, retain) NSMutableArray *selectedUsers;

- (void)createMeetingButtonPressed;

@end
