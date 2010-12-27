//
//  RegisterViewController.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UITableViewController {
	NSDictionary *tableData;
	NSArray *tableKeys;
	UITextField *firstNameTextField;
	UITextField *lastNameTextField;
	NSString *uniqueidLabel;
	NSString *passwordLabel;
}

@property (nonatomic, retain) UITextField *firstNameTextField;
@property (nonatomic, retain) UITextField *lastNameTextField;

@end
