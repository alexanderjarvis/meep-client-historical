//
//  LoginViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

#import "LoginManager.h"
#import "CustomCellTextField.h"

@interface LoginViewController : UIViewController {
	
	IBOutlet UITableView *tableView;
	
	MBProgressHUD *HUD;
	
	LoginManager *loginManager;
	
	CustomCellTextField *emailCell;
	CustomCellTextField *passwordCell;
	
	CustomCellTextField *selectedCell;
}

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) CustomCellTextField *emailCell;
@property (nonatomic, retain) CustomCellTextField *passwordCell;

- (IBAction)loginButtonPressed;

- (void)textFieldCell:(CustomCellTextField *)cell returnInTableView:(UITableView *)tableView;

@end
