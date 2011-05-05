//
//  RegisterViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 Alex Jarvis. All rights reserved.
//

#import "RegisterViewController.h"

#import "MeepAppDelegate.h"
#import "AlertView.h"
#import "CustomCellTextField.h"
#import "MeepStyleSheet.h"
#import "TTFixedWidthButton.h"

@implementation RegisterViewController

@synthesize registerButton;
@synthesize hud;
@synthesize emailCell;
@synthesize passwordCell;
@synthesize firstNameCell;
@synthesize lastNameCell;
@synthesize mobileNumberCell;
@synthesize selectedCell;
@synthesize cellsToValidate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = @"Register";
	
	hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
	hud.labelText = @"Registering...";
	
	registrationManager = [[RegistrationManager alloc] init];
	[registrationManager setDelegate:self];
    
    [TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	TTFixedWidthButton *button = [TTFixedWidthButton buttonWithStyle:@"blueButton:" title:@"Register"];
	button.font = [UIFont boldSystemFontOfSize:17];
    button.width = 200;
	[button sizeToFit];
	[button addTarget:self action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[registerButton addSubview:button];
    
    self.cellsToValidate = [NSMutableArray arrayWithCapacity:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)registerButtonPressed {
    
    // Validation
    for (CustomCellTextField *cell in cellsToValidate) {
        if (cell.required && cell.customTextField.text.length < 1) {
            [AlertView showValidationAlert:[cell.customTextLabel.text stringByAppendingString:@" is blank"]];
            return;
        }
    }
    
	// Hide the keyboard
	if (selectedCell != nil) {
		[selectedCell.customTextField resignFirstResponder];
	}
    
    // Show the HUD
	[hud show:YES];
	
	// Build up the User data and register the user.
	UserDTO *user = [[UserDTO alloc] init];
	user.email = [emailCell.customTextField text];
	user.password = [passwordCell.customTextField text];
	user.firstName = [firstNameCell.customTextField text];
	user.lastName = [lastNameCell.customTextField text];
	user.mobileNumber = [mobileNumberCell.customTextField text];
	
	[registrationManager registerUser:user];
    [user release];
}

/*
 * To be called when the 'Next' key is pressed from the keyboard.
 */
- (void)textFieldCellReturned:(CustomCellTextField *)cell inTableView:(UITableView *)tableView; {
    
	NSIndexPath *indexPath = [tableView indexPathForCell:cell];
	
	// If not the last cell, go to next cell
	if (cell.customTextField.returnKeyType == UIReturnKeyNext) {
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
		[self tableView:tableView didSelectRowAtIndexPath:newIndexPath];
	} else if (cell.customTextField.returnKeyType == UIReturnKeyDone) {
		[self registerButtonPressed];
	}
}

- (void)dealloc {
    [registerButton release];
	[hud release];
	[registrationManager release];
	[emailCell release];
	[passwordCell release];
	[firstNameCell release];
	[lastNameCell release];
	[mobileNumberCell release];
    [cellsToValidate release];
    [super dealloc];
}

#pragma mark UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
        [cellsToValidate addObject:cell];
	}
	
	switch (row) {
		case 0:
			if (self.emailCell == nil) {
				cell.customTextLabel.text = @"Email";
				[cell setRequired: YES];
				cell.customTextField.returnKeyType = UIReturnKeyNext;
				cell.customTextField.keyboardType = UIKeyboardTypeEmailAddress;
				self.emailCell = cell;
			} else {
				cell = self.emailCell;
			}			
			break;
		case 1:
			if (self.firstNameCell == nil) {
				cell.customTextLabel.text = @"First name";
				[cell setRequired: YES];
				cell.customTextField.returnKeyType = UIReturnKeyNext;
				cell.customTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
				self.firstNameCell = cell;
			} else {
				cell = self.firstNameCell;
			}
			break;
		case 2:
			if (self.lastNameCell == nil) {
				cell.customTextLabel.text = @"Last name";
				[cell setRequired: YES];
				cell.customTextField.returnKeyType = UIReturnKeyNext;
				cell.customTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
				self.lastNameCell = cell;
			} else {
				cell = self.lastNameCell;
			}
			break;
		case 3:
			if (self.passwordCell == nil) {
				cell.customTextLabel.text = @"Password";
				[cell setRequired: YES];
				cell.customTextField.returnKeyType = UIReturnKeyNext;
				cell.customTextField.secureTextEntry = YES;
				self.passwordCell = cell;
			} else {
				cell = self.passwordCell;
			}
			break;
		case 4:
			if (self.mobileNumberCell == nil) {
				cell.customTextLabel.text = @"Mobile #";
				[cell setRequired: NO];
				cell.customTextField.returnKeyType = UIReturnKeyDone;
				cell.customTextField.keyboardType = UIKeyboardTypeNumberPad;
				self.mobileNumberCell = cell;
			} else {
				cell = self.mobileNumberCell;
			}
			break;
		default:
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	CustomCellTextField *cell = (CustomCellTextField *)[tableView cellForRowAtIndexPath:indexPath];
	[cell.customTextField becomeFirstResponder];
	
	selectedCell = cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
	if (section == 0) {
		return @"Please enter your details"; 
	}
	return nil;
}

#pragma mark -
#pragma mark RegistrationManagerDelegate

- (void)userRegistrationSuccessful {
    
	[hud hide:YES];
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[meepAppDelegate showMenuView];
}

- (void)userRegistrationFailedWithError:(NSError *)error {
	[hud hide:YES];
	[AlertView showValidationAlert:[error localizedDescription]];
}

- (void)userRegistrationFailedWithNetworkError:(NSError *)error {
	[hud hide:YES];
	[AlertView showNetworkAlert:error];
}

@end
