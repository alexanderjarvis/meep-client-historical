//
//  UserDetailViewController.h
//  Meep
//
//  Created by Alex Jarvis on 03/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

#import "AddUserRequestManager.h"
#import "DeleteUserRequestManager.h"
#import "UserDTO.h"
#import "MBProgressHUD.h"
#import "TTFixedWidthButton.h"

@interface UserDetailViewController : UITableViewController {
    
    IBOutlet UIView *tableFooterButtonView;
	TTFixedWidthButton *ttButton;
	
	AddUserRequestManager *addUserRequestManager;
    DeleteUserRequestManager *deleteUserRequestManager;
	UserDTO *user;
    
    MBProgressHUD *hud;
    
    UIAlertView *deleteUserAlertView;
    
}

@property (nonatomic, retain) UIView *tableFooterButtonView;
@property (nonatomic, retain) UserDTO *user;

- (void)requestAddUserButtonPressed;
- (void)deleteUserButtonPressed;

@end
