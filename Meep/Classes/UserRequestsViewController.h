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
#import "AcceptUserRequestManager.h"
#import "DeclineUserRequestManager.h"

@interface UserRequestsViewController : UITableViewController {
	
	UserManager *userManager;	
	User *currentUser;
	AcceptUserRequestManager *acceptUserRequestManager;
	DeclineUserRequestManager *declineUserRequestManager;

}

@property (nonatomic, retain) UserManager *userManager;
@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) AcceptUserRequestManager *acceptUserRequestManager;
@property (nonatomic, retain) DeclineUserRequestManager *declineUserRequestManager;

-(void)acceptUserAtIndexPath:(NSIndexPath *)indexPath;
-(void)declineUserAtIndexPath:(NSIndexPath *)indexPath;

@end
