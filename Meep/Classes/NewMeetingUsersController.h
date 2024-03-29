//
//  NewMeetingUsersController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserManager.h"
#import "UserDTO.h"
#import "CreateMeetingRequestManager.h"
#import "MBProgressHUD.h"

@interface NewMeetingUsersController : UITableViewController <CreateMeetingRequestManagerDelegate, UIAlertViewDelegate> {
	
    MBProgressHUD *hud;
    
	IBOutlet UIButton *createMeetingButton;
	
	CreateMeetingRequestManager *createMeetingRequestManager;
	
	NSArray *tableKeys;
	NSDictionary *tableDictionary;
	NSMutableArray *selectedUsers;
	
}

@property(nonatomic, retain) UIButton *createMeetingButton;

@property(nonatomic, retain) CreateMeetingRequestManager *createMeetingRequestManager;

@property(nonatomic, retain) NSArray *tableKeys;
@property(nonatomic, retain) NSDictionary *tableDictionary;
@property(nonatomic, retain) NSMutableArray *selectedUsers;

- (void)createMeetingButtonPressed;
- (void)updateTableWithUser:(UserDTO *)user;

@end
