//
//  RegisterViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

#import "CustomCellTextField.h"


@interface RegisterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	MBProgressHUD *HUD;
	
	UITextField *emailTextField;
	UITextField *passwordTextField;
	UITextField *firstNameTextField;
	UITextField *lastNameTextField;
	UITextField *userNameTextField;
	UITextField *mobileNumberTextField;
}

@property (nonatomic, retain) UITextField *emailTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *firstNameTextField;
@property (nonatomic, retain) UITextField *lastNameTextField;
@property (nonatomic, retain) UITextField *userNameTextField;
@property (nonatomic, retain) UITextField *mobileNumberTextField;

- (void)showHUDWithLabel:(id)sender;

- (void)myTask;

- (IBAction)registerButtonPressed;

- (void)textFieldCell:(CustomCellTextField *)cell returnInTableView:(UITableView *)tableView;


@end
