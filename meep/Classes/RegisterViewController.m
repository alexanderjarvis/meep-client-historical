//
//  RegisterViewController.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"

#import "CustomCellTextField.h"

@implementation RegisterViewController

@synthesize firstNameTextField;
@synthesize lastNameTextField;

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
	[firstNameTextField release];
	[lastNameTextField release];
	
    [super dealloc];
}

#pragma mark Table view methods

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
	}
	
	// TODO switch
	if (row == 0) {
		cell.customTextLabel.text = @"First name";
		firstNameTextField = cell.customTextField;
		[firstNameTextField addTarget:self action:@selector(textFieldUpdated:) forControlEvents:UIControlEventEditingChanged];
		firstNameTextField.returnKeyType = UIReturnKeyNext;
	} else if (row == 1) {
		cell.customTextLabel.text = @"Last name";
		lastNameTextField = cell.customTextField;
		[lastNameTextField addTarget:self action:@selector(textFieldUpdated:) forControlEvents:UIControlEventEditingChanged];
		lastNameTextField.returnKeyType = UIReturnKeyDone;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Please enter your details"; 
	}
	return nil;
}

@end
