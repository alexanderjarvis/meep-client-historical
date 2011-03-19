//
//  RegisterViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

#import "RegistrationManager.h"
#import "CustomCellTextField.h"
#import "UserDTO.h"

@interface RegisterViewController : UITableViewController <RegistrationManagerDelegate> {
    
    IBOutlet UIButton *registerButton;
	
	MBProgressHUD *hud;
	
	RegistrationManager *registrationManager;
	
	CustomCellTextField *emailCell;
	CustomCellTextField *passwordCell;
	CustomCellTextField *firstNameCell;
	CustomCellTextField *lastNameCell;
	CustomCellTextField *mobileNumberCell;
	CustomCellTextField *selectedCell;
    NSMutableArray *cellsToValidate;
    
}

@property (nonatomic, retain) UIButton *registerButton;

@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) CustomCellTextField *emailCell;
@property (nonatomic, retain) CustomCellTextField *passwordCell;
@property (nonatomic, retain) CustomCellTextField *firstNameCell;
@property (nonatomic, retain) CustomCellTextField *lastNameCell;
@property (nonatomic, retain) CustomCellTextField *mobileNumberCell;
@property (nonatomic, assign) CustomCellTextField *selectedCell;
@property (nonatomic, retain) NSMutableArray *cellsToValidate;

- (void)registerButtonPressed;

- (void)textFieldCellReturned:(CustomCellTextField *)cell inTableView:(UITableView *)tableView;

@end
