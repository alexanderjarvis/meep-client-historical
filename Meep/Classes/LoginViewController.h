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

@interface LoginViewController : UITableViewController <LoginManagerDelegate> {
	
    IBOutlet UIButton *loginButton;
	
    MBProgressHUD *hud;
	
	LoginManager *loginManager;
	
	CustomCellTextField *emailCell;
	CustomCellTextField *passwordCell;
	CustomCellTextField *selectedCell;
    NSMutableArray *cellsToValidate;
    
}

@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) CustomCellTextField *emailCell;
@property (nonatomic, retain) CustomCellTextField *passwordCell;
@property (nonatomic, assign) CustomCellTextField *selectedCell;
@property (nonatomic, retain) NSMutableArray *cellsToValidate;

- (void)loginButtonPressed;

- (void)textFieldCellReturned:(CustomCellTextField *)cell inTableView:(UITableView *)tableView;

@end
