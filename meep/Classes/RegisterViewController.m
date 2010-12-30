//
//  RegisterViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"

#import "CustomCellTextField.h"

#import "ASIFormDataRequest.h"

#import <objc/runtime.h>

@implementation RegisterViewController

@synthesize emailCell;
@synthesize passwordCell;
@synthesize firstNameCell;
@synthesize lastNameCell;
@synthesize mobileNumberCell;

- (void)viewDidLoad {
	self.title = @"Register";
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
	HUD.labelText = @"Registering...";
	
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
	[emailCell release];
	[passwordCell release];
	[firstNameCell release];
	[lastNameCell release];
	[mobileNumberCell release];
    [super dealloc];
}

- (IBAction)registerButtonPressed{
	NSLog(@"registerButtonPressed");
	
	if (emailCell.required && emailCell.customTextField.text.length < 1) {
		NSLog(@"alert! email is blank");
		[self.navigationController showValidationAlert:@"Email is blank"];		
	}
	
	// move
	UserDTO *userDTO = [[UserDTO alloc] init];
	userDTO.email = [emailCell.customTextField text];
	userDTO.password = [passwordCell.customTextField text];
	userDTO.firstName = [firstNameCell.customTextField text];
	userDTO.lastName = [lastNameCell.customTextField text];
	userDTO.mobileNumber = [mobileNumberCell.customTextField text];
	
	if (selectedCell != nil) {
		[selectedCell.customTextField resignFirstResponder];
	}
	[HUD show:YES];
	
	[self registerUser:userDTO];
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
		[self registerButtonPressed];
	}
}

#pragma mark UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
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
	CustomCellTextField *cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell.customTextField becomeFirstResponder];
	
	selectedCell = cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Please enter your details"; 
	}
	return nil;
}

#pragma mark ASI request methods

- (void)registerUser:(UserDTO *)user {
	NSURL *url = [NSURL URLWithString:@"http://localhost:9000/users"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setDelegate:self];
	
	// TODO move to another class and method
	// Get properties for class
	Class clazz = [user class];
    u_int count;
	
    objc_property_t * properties = class_copyPropertyList(clazz, &count);
    NSMutableArray * propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
	
	// Add properties to request
	for (int i = 0; i < [propertyArray count]; i++) {
		NSString *key = [NSString stringWithFormat:@"user.%@", [propertyArray objectAtIndex:i]];
		NSString *value = [user valueForKey:[propertyArray objectAtIndex:i]];
		[request setPostValue:value forKey:key];
	}
	
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);;
	
	sleep(1);
	[HUD hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog([error localizedDescription]);
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);
	
	[HUD hide:YES];
}

@end
