//
//  SearchUsersDetailViewController.h
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddUserRequestManager.h"
#import "User.h"

@interface SearchUsersDetailViewController : UITableViewController <AddUserRequestManagerDelegate> {
	
	AddUserRequestManager *addUserRequestManager;
	User *user;

}

@property (nonatomic, retain) AddUserRequestManager *addUserRequestManager;
@property (nonatomic, retain) User *user;

- (IBAction)requestAddUser;

@end
