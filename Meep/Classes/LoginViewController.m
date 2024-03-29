//
//  LoginViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 Alex Jarvis. All rights reserved.
//

#import "LoginViewController.h"

#import "MeepAppDelegate.h"
#import "AlertView.h"
#import "MeepStyleSheet.h"
#import "TTFixedWidthButton.h"

@implementation LoginViewController

@synthesize loginButton;
@synthesize hud;
@synthesize emailCell;
@synthesize passwordCell;
@synthesize selectedCell;
@synthesize cellsToValidate;

- (void)viewDidLoad {
    
	self.title = @"Login";
	
	hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
	hud.labelText = @"Logging in...";
	
	loginManager = [[LoginManager alloc] init];
	[loginManager setDelegate:self];
    
    [TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	TTFixedWidthButton *button = [TTFixedWidthButton buttonWithStyle:@"blueButton:" title:@"Login"];
	button.font = [UIFont boldSystemFontOfSize:17];
    button.width = 200;
	[button sizeToFit];
	[button addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[loginButton addSubview:button];
    
    self.cellsToValidate = [NSMutableArray arrayWithCapacity:2];
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)loginButtonPressed {
    
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
	
    // Build up user data and login
	UserDTO *user = [[UserDTO alloc] init];
	user.email = [emailCell.customTextField text];
	user.password = [passwordCell.customTextField text];
	
	[loginManager loginUser:user];
	[user release];
}

/*
 * To be called when the 'Next' key is pressed from the keyboard.
 */
- (void)textFieldCellReturned:(CustomCellTextField *)cell inTableView:(UITableView *)tableView {
    
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
    [loginButton release];
	[hud release];
	[loginManager release];
	[emailCell release];
	[passwordCell release];
    [cellsToValidate release];
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
    
	[hud hide:YES];
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[meepAppDelegate showMenuView];
}

- (void)loginFailedWithError:(NSError *)error {
	[hud hide:YES];
	[AlertView showValidationAlert:[error localizedDescription]];
}

- (void)loginFailedWithNetworkError:(NSError *)error {
	[hud hide:YES];
	[AlertView showNetworkAlert:error];
}


@end
