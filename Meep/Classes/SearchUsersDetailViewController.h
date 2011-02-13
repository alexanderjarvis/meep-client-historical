//
//  SearchUsersDetailViewController.h
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "AddUserRequestManager.h"

@interface SearchUsersDetailViewController : UITableViewController {
	
	User *user;
	AddUserRequestManager *addUserRequestManager;

}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) AddUserRequestManager *addUserRequestManager;

- (IBAction)requestAddUser;

@end
