//
//  LoginViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginManager.h"
#import "MBProgressHUD.h"

#import "CustomCellTextField.h"

@interface LoginViewController : UITableViewController <UITextFieldDelegate, LoginManagerDelegate> {
	
	MBProgressHUD *HUD;
	
	LoginManager *loginManager;
	
	CustomCellTextField *emailCell;
	CustomCellTextField *passwordCell;
	
	CustomCellTextField *selectedCell;
    
    IBOutlet UIButton *loginButton;
}

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) CustomCellTextField *emailCell;
@property (nonatomic, retain) CustomCellTextField *passwordCell;
@property (nonatomic, retain) UIButton *loginButton;

- (void)loginButtonPressed;

- (void)textFieldCell:(CustomCellTextField *)cell returnInTableView:(UITableView *)tableView;

@end
