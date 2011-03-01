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

@interface NewMeetingUsersController : UITableViewController <UserManagerDelegate> {
	
	UserManager *userManager;
	User *currentUser;
	
	NSArray *tableKeys;
	NSDictionary *tableDictionary;
	
}

@property(nonatomic, retain) UserManager *userManager;
@property(nonatomic, retain) User *currentUser;

@property(nonatomic, retain) NSArray *tableKeys;
@property(nonatomic, retain) NSDictionary *tableDictionary;

@end
