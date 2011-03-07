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
	
	MBProgressHUD *HUD;
	
	RegistrationManager *registrationManager;
	
	CustomCellTextField *emailCell;
	CustomCellTextField *passwordCell;
	CustomCellTextField *firstNameCell;
	CustomCellTextField *lastNameCell;
	CustomCellTextField *mobileNumberCell;
	
	CustomCellTextField *selectedCell;
    
    IBOutlet UIButton *registerButton;
}

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) CustomCellTextField *emailCell;
@property (nonatomic, retain) CustomCellTextField *passwordCell;
@property (nonatomic, retain) CustomCellTextField *firstNameCell;
@property (nonatomic, retain) CustomCellTextField *lastNameCell;
@property (nonatomic, retain) CustomCellTextField *mobileNumberCell;
@property (nonatomic, retain) UIButton *registerButton;

- (void)registerButtonPressed;

- (void)textFieldCell:(CustomCellTextField *)cell returnInTableView:(UITableView *)tableView;


@end
