//
//  MyDetailsViewController.m
//  Meep
//
//  Created by Alex Jarvis on 04/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDetailsViewController.h"

#import "MeepAppDelegate.h"
#import "AlertView.h"
#import "CustomCellTextField.h"
#import "MeepStyleSheet.h"
#import "TTFixedWidthButton.h"

@interface MyDetailsViewController (private)

- (void)updateTableWithCurrentUser;
- (void)editButtonPressed;
- (void)updateButtonPressed;

@end

@implementation MyDetailsViewController

@synthesize tableFooterButtonView;
@synthesize hud;
@synthesize emailCell;
@synthesize passwordCell;
@synthesize firstNameCell;
@synthesize lastNameCell;
@synthesize mobileNumberCell;
@synthesize selectedCell;
@synthesize cellsToValidate;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [editButton release];
    [doneButton release];
    [updateUserRequestManager release];
    [tableFooterButton release];
    [tableFooterButtonView release];
	[hud release];
	[emailCell release];
	[passwordCell release];
	[firstNameCell release];
	[lastNameCell release];
	[mobileNumberCell release];
    [cellsToValidate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Details";
    
    editButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                target:self
                                                                action:@selector(editButtonPressed)] retain];
    doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                target:self
                                                                action:@selector(updateButtonPressed)] retain];
	self.navigationItem.rightBarButtonItem = editButton;
	
	hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
	hud.labelText = @"Updating...";
    
    NSString *accessToken = [[[MeepAppDelegate sharedAppDelegate] configManager] accessToken];
    updateUserRequestManager = [[UpdateUserRequestManager alloc] initWithAccessToken:accessToken];
    updateUserRequestManager.delegate = self;
	
	// Button
    [TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	tableFooterButton = [[TTFixedWidthButton buttonWithStyle:@"blueButton:" title:@"Update"] retain];
	tableFooterButton.font = [UIFont boldSystemFontOfSize:17];
    tableFooterButton.width = 200;
	[tableFooterButton sizeToFit];
	[tableFooterButton addTarget:self action:@selector(updateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    tableFooterButton.enabled = NO;
    [tableFooterButtonView addSubview:tableFooterButton];
    
    self.cellsToValidate = [NSMutableArray arrayWithCapacity:4];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateTableWithCurrentUser];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark private

- (void)updateTableWithCurrentUser {
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    emailCell.customTextField.text = currentUser.email;
    firstNameCell.customTextField.text = currentUser.firstName;
    lastNameCell.customTextField.text = currentUser.lastName;
    mobileNumberCell.customTextField.text = currentUser.mobileNumber;
}

- (void)editButtonPressed {
    for (CustomCellTextField *cell in cellsToValidate) {
        cell.customTextField.enabled = YES;
        cell.customTextField.textColor = [UIColor blackColor];
    }
    
	self.navigationItem.rightBarButtonItem = doneButton;
    
    tableFooterButton.enabled = YES;
}

- (void)updateButtonPressed {
    
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
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	UserDTO *user = [[UserDTO alloc] init];
    user._id = currentUser._id;
	user.email = [emailCell.customTextField text];
	user.password = [passwordCell.customTextField text];
	user.firstName = [firstNameCell.customTextField text];
	user.lastName = [lastNameCell.customTextField text];
	user.mobileNumber = [mobileNumberCell.customTextField text];
	
	[updateUserRequestManager updateUser:user];
    [user release];
}

#pragma mark -
#pragma mark MyDetailsViewController

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
		[self updateButtonPressed];
	}
}


#pragma mark - Table view data source

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
        cell.customTextField.enabled = NO;
        cell.customTextField.textColor = [UIColor grayColor];
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
				[cell setRequired: NO];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
	if (section == 0) {
		return @"Update Your Details";
	}
	return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	CustomCellTextField *cell = (CustomCellTextField *)[tableView cellForRowAtIndexPath:indexPath];
	[cell.customTextField becomeFirstResponder];
	
	selectedCell = cell;
}

#pragma mark - 
#pragma mark UpdateUserRequestManagerDelegate

- (void)updateUserSuccessful {
    [hud hide:YES];
    
    self.navigationItem.rightBarButtonItem = editButton;
    tableFooterButton.enabled = NO;
    for (CustomCellTextField *cell in cellsToValidate) {
        cell.customTextField.enabled = NO;
        cell.customTextField.textColor = [UIColor grayColor];
    }
}

- (void)updateUserFailedWithError:(NSError *)error {
    [hud hide:YES];
    [AlertView showValidationAlert:[error localizedDescription]];
}

- (void)updateUserFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
    [AlertView showNetworkAlert:error];
}

@end
