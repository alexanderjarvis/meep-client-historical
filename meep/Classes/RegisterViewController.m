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
	
	[self showHUDWithLabel:self];
	
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

- (void)showHUDWithLabel:(id)sender {
	// The hud will disable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Registering...";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)myTask {
	sleep(3);
}

- (IBAction)registerButtonPressed{
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

/*
 * To be called when the 'Next' key is pressed from the keyboard.
 */
- (void)textFieldCell:(CustomCellTextField *)cell returnInTableView:(UITableView *)tableView {
	NSIndexPath *indexPath = [tableView indexPathForCell:cell];
	
	// If not the last cell, go to next cell
	if (cell.customTextField.returnKeyType == UIReturnKeyNext) {
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
		[self tableView:tableView didSelectRowAtIndexPath:newIndexPath];
	} else if (cell.customTextField.returnKeyType == UIReturnKeyDone) {
		//[cell.customTextField resignFirstResponder];
		[self registerButtonPressed];
	}
}

#pragma mark UITableViewController methods

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
		cell.tableView = tableView;
		cell.tableViewController = self;
	}
	
	switch (row) {
		case 0:
			cell.customTextLabel.text = @"Email";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			cell.customTextField.keyboardType = UIKeyboardTypeEmailAddress;
			emailTextField = [cell.customTextField retain];
			break;
		case 1:
			cell.customTextLabel.text = @"Password";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			cell.customTextField.secureTextEntry = YES;
			passwordTextField = [cell.customTextField retain];
			break;
		case 2:
			cell.customTextLabel.text = @"First name";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			cell.customTextField.autocorrectionType = UITextAutocapitalizationTypeWords;
			firstNameTextField = [cell.customTextField retain];
			break;
		case 3:
			cell.customTextLabel.text = @"Last name";
			cell.customTextField.placeholder = @"required";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			cell.customTextField.autocorrectionType = UITextAutocapitalizationTypeWords;
			lastNameTextField = [cell.customTextField retain];
			break;
		case 4:
			cell.customTextLabel.text = @"Username";
			cell.customTextField.returnKeyType = UIReturnKeyNext;
			userNameTextField = [cell.customTextField retain];
			break;
		case 5:
			cell.customTextLabel.text = @"Mobile #";
			cell.customTextField.returnKeyType = UIReturnKeyDone;
			cell.customTextField.keyboardType = UIKeyboardTypeNumberPad;
			mobileNumberTextField = [cell.customTextField retain];
			break;
		default:
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
