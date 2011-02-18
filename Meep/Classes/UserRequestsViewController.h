//
//  UserRequestsViewController.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserManager.h"
#import "User.h"

@interface UserRequestsViewController : UITableViewController {
	
	UserManager *userManager;	
	User *currentUser;

}

@property (nonatomic, retain) UserManager *userManager;
@property (nonatomic, retain) User *currentUser;

@end
