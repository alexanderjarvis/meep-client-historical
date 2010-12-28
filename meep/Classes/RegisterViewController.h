//
//  RegisterViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UITableViewController {
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

-(IBAction)registerButtonPressed;

@end
