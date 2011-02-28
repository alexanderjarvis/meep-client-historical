//
//  LoginViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

#import "MeepAppDelegate.h"
#import "AlertView.h"

@implementation LoginViewController

@synthesize HUD;
@synthesize emailCell;
@synthesize passwordCell;

- (void)viewDidLoad {
	self.title = @"Login";
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
	HUD.labelText = @"Logging in...";
	
	loginManager = [[LoginManager alloc] init];
	[loginManager setDelegate:self];
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)loginButtonPressed {
	 
	[emailCell.customTextField resignFirstResponder];
	[passwordCell.customTextField resignFirstResponder];
	
	[HUD show:YES];
	
	UserDTO *userDTO = [[UserDTO alloc] init];
	userDTO.email = [emailCell.customTextField text];
	userDTO.password = [passwordCell.customTextField text];
	
	[loginManager loginUser:userDTO];
	[userDTO release];
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
		[self loginButtonPressed];
	}
}

- (void)dealloc {
	[HUD release];
	[loginManager release];
	[emailCell release];
	[passwordCell release];
	
    [super dealloc];
}

#pragma mark UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
			if (self.passwordCell == nil) {
				cell.customTextLabel.text = @"Password";
				[cell setRequired: YES];
				cell.customTextField.returnKeyType = UIReturnKeyDone;
				cell.customTextField.secureTextEntry = YES;
				self.passwordCell = cell;
			} else {
				cell = self.passwordCell;
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
#pragma mark LoginManagerDelegate

- (void)loginSuccessful {
	[HUD hide:YES];
	self.passwordCell.customTextField.text = @"";
	[self.navigationController popViewControllerAnimated:NO];
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[meepAppDelegate showMenuView];
}

- (void)loginFailedWithError:(NSError *)error {
	[HUD hide:YES];
	[AlertView showValidationAlert:[error localizedDescription]];
}

- (void)loginFailedWithNetworkError:(NSError *)error {
	[HUD hide:YES];
	[AlertView showNetworkAlert:error];
}


@end
