//
//  RegisterViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"

#import "CustomCellTextField.h"
#import "UserDTO.h"

@implementation RegisterViewController

@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize userNameTextField;
@synthesize mobileNumberTextField;

- (void)viewDidLoad {
	self.title = @"Register";
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[emailTextField release];
	[passwordTextField release];
	[firstNameTextField release];
	[lastNameTextField release];
	[userNameTextField release];
	[mobileNumberTextField release];
	
    [super dealloc];
}

-(IBAction)registerButtonPressed {
	NSLog(@"registerButtonPressed");
	
	// move
	UserDTO *userDTO = [[UserDTO alloc] init];
	userDTO.email = [emailTextField text];
	userDTO.password = [passwordTextField text];
	userDTO.firstName = [firstNameTextField text];
	userDTO.lastName = [lastNameTextField text];
	userDTO.userName = [userNameTextField text];
	userDTO.mobileNumber = [mobileNumberTextField text];
	
	NSLog([userDTO paramString]);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
	CustomCellTextField *cell = (CustomCellTextField *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellTextField" 
													 owner:self options:nil];
		
		cell = (CustomCellTextField *)[nib objectAtIndex:0];
	}
	
	// TODO switch
	switch (row) {
		case 0:
			cell.customTextLabel.text = @"Email";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			emailTextField = cell.customTextField;
			break;
		case 1:
			cell.customTextLabel.text = @"Password";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			passwordTextField = cell.customTextField;
			break;
		case 2:
			cell.customTextLabel.text = @"First name";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			firstNameTextField = cell.customTextField;
			break;
		case 3:
			cell.customTextLabel.text = @"Last name";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			lastNameTextField = cell.customTextField;
			break;
		case 4:
			cell.customTextLabel.text = @"Username";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			userNameTextField = cell.customTextField;
			break;
		case 5:
			cell.customTextLabel.text = @"Mobile #";
			cell.customTextField.returnKeyType = UIReturnKeyDone;
			mobileNumberTextField = cell.customTextField;
			break;
		default:
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"did select row");
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	CustomCellTextField *cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell.customTextField becomeFirstResponder];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Please enter your details"; 
	}
	return nil;
}

@end
