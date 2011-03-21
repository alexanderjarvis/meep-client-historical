//
//  SearchUsersDetailViewController.h
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

#import "AddUserRequestManager.h"
#import "UserDTO.h"
#import "MBProgressHUD.h"

@interface SearchUsersDetailViewController : UITableViewController <AddUserRequestManagerDelegate> {
	
	IBOutlet UIButton *requestAddUserButton;
	TTButton *tt_requestAddUserButton;
	
	AddUserRequestManager *addUserRequestManager;
	UserDTO *user;
    
    MBProgressHUD *hud;

}

@property (nonatomic, retain) UIButton *requestAddUserButton;
@property (nonatomic, retain) AddUserRequestManager *addUserRequestManager;
@property (nonatomic, retain) UserDTO *user;

- (void)requestAddUserButtonPressed;

@end
