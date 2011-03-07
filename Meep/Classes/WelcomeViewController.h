//
//  WelcomeViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController {
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registerButton;

}

@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIButton *registerButton;

- (IBAction)loginButtonPressed;

- (IBAction)registerButtonPressed;

@end
