//
//  MyDetailsViewController.h
//  Meep
//
//  Created by Alex Jarvis on 04/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTFixedWidthButton.h"
#import "MBProgressHUD.h"

#import "CustomCellTextField.h"
#import "UserDTO.h"
#import "UpdateUserRequestManager.h"

@interface MyDetailsViewController : UITableViewController <UpdateUserRequestManagerDelegate> {
    
    IBOutlet UIView *tableFooterButtonView;
	TTFixedWidthButton *tableFooterButton;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
	MBProgressHUD *hud;
    
    UpdateUserRequestManager *updateUserRequestManager;
	
	CustomCellTextField *emailCell;
	CustomCellTextField *passwordCell;
	CustomCellTextField *firstNameCell;
	CustomCellTextField *lastNameCell;
	CustomCellTextField *mobileNumberCell;
	CustomCellTextField *selectedCell;
    NSMutableArray *cellsToValidate;
    
}

@property (nonatomic, retain) UIView *tableFooterButtonView;

@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) CustomCellTextField *emailCell;
@property (nonatomic, retain) CustomCellTextField *passwordCell;
@property (nonatomic, retain) CustomCellTextField *firstNameCell;
@property (nonatomic, retain) CustomCellTextField *lastNameCell;
@property (nonatomic, retain) CustomCellTextField *mobileNumberCell;
@property (nonatomic, assign) CustomCellTextField *selectedCell;
@property (nonatomic, retain) NSMutableArray *cellsToValidate;

- (void)textFieldCellReturned:(CustomCellTextField *)cell inTableView:(UITableView *)tableView;

@end