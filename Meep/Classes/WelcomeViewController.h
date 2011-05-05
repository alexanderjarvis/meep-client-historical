//
//  WelcomeViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface WelcomeViewController : UIViewController {
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registerButton;
    
    RegisterViewController *registerViewController;
	LoginViewController *loginViewController;

}

@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIButton *registerButton;

@property (nonatomic, retain) RegisterViewController *registerViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;

- (void)loginButtonPressed;
- (void)registerButtonPressed;

@end
