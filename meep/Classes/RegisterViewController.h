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


@interface RegisterViewController : UITableViewController {
	
	IBOutlet UITableView *tableView;
	
	MBProgressHUD *HUD;
	
	CustomCellTextField *emailCell;
	CustomCellTextField *passwordCell;
	CustomCellTextField *firstNameCell;
	CustomCellTextField *lastNameCell;
	CustomCellTextField *mobileNumberCell;
}

@property (nonatomic, retain) CustomCellTextField *emailCell;
@property (nonatomic, retain) CustomCellTextField *passwordCell;
@property (nonatomic, retain) CustomCellTextField *firstNameCell;
@property (nonatomic, retain) CustomCellTextField *lastNameCell;
@property (nonatomic, retain) CustomCellTextField *mobileNumberCell;

- (void)showHUDWithLabel:(id)sender;

- (void)myTask;

- (IBAction)registerButtonPressed;

- (void)textFieldCell:(CustomCellTextField *)cell returnInTableView:(UITableView *)tableView;


@end
