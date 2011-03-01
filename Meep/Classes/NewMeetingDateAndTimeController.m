//
//  NewMeetingDateAndTimeController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMeetingDateAndTimeController.h"

#import "MeepAppDelegate.h"

@implementation NewMeetingDateAndTimeController

@synthesize choosePeopleButton;
@synthesize datePicker;
@synthesize dateCell;
@synthesize titleCell;
@synthesize descriptionCell;

- (void)viewDidLoad {
	
	self.title = @"Date & Time";
	
	datePicker = [[UIDatePicker alloc] init];
	datePicker.minimumDate = [NSDate date];
	[datePicker addTarget:self action:@selector(datePickerUpdated) forControlEvents:UIControlEventValueChanged];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	TTButton *button = [TTButton buttonWithStyle:@"toolbarForwardButton:" title:@"Choose People"];
	button.font = [UIFont boldSystemFontOfSize:15];
	[button sizeToFit];
	[button addTarget:self action:@selector(choosePeopleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[choosePeopleButton addSubview: button];
	
    [super viewDidLoad];
}

- (void)choosePeopleButtonPressed {
	NSLog(@"Choose People button pressed");
	
	// do something with date
	[datePicker date];
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[meepAppDelegate.menuNavigationController showNewMeetingUsers];
}

- (TTPostController *)showPostController {
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:descriptionCell.customTextField.text, @"text", 
																			self, @"delegate",
																			descriptionCell.customTextField, @"__target__",nil];
																			
	TTPostController *controller = [[[TTPostController alloc] initWithNavigatorURL:nil
																			 query:dictionary] autorelease];
	return controller;
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

/*
 * To be called when the 'Next' key is pressed from the keyboard.
 */
- (void)textFieldCell:(CustomCellTextField *)cell returnInTableView:(UITableView *)tableView {
	NSIndexPath *indexPath = [tableView indexPathForCell:cell];
	
	// If not the last cell, go to next cell
	if (cell.customTextField.returnKeyType == UIReturnKeyNext) {
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
		[self tableView:tableView didSelectRowAtIndexPath:newIndexPath];
	}
}

- (void)datePickerUpdated {
	dateCell.customTextField.text = [dateFormatter stringFromDate:[datePicker date]];
}

- (void)dealloc {
	[dateFormatter release];
	[choosePeopleButton release];
	[datePicker release];
	[dateCell release];
	[titleCell release];
	[descriptionCell release];
    [super dealloc];
}

#pragma mark UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
		cell.customTextField.delegate = self;
		cell.customTextLabel.font = [cell.customTextLabel.font fontWithSize:15];
	}
	
	switch (row) {
		case 0:
			if (self.titleCell == nil) {
				cell.customTextLabel.text = @"Title";
				[cell setRequired: YES];
				cell.customTextField.returnKeyType = UIReturnKeyNext;
				cell.customTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
				cell.customTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
				self.titleCell = cell;
			} else {
				cell = self.titleCell;
			}			
			break;
		case 1:
			if (self.dateCell == nil) {
				cell.customTextLabel.text = @"Date";
				[cell setRequired: YES];
				cell.customTextField.inputView = datePicker;
				self.dateCell = cell;
			} else {
				cell = self.dateCell;
			}			
			break;
		case 2:
			if (self.descriptionCell == nil) {
				cell.customTextLabel.text = @"Description";
				self.descriptionCell = cell;
			} else {
				cell = self.descriptionCell;
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
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Meeting details"; 
	}
	return nil;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == descriptionCell.customTextField) {
		TTPostController *postController = [self showPostController];
		[postController showInView:self.view animated:YES];
		return NO;
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (textField == dateCell.customTextField) {
		dateCell.customTextField.text = [dateFormatter stringFromDate:[datePicker date]];
	}
}

#pragma mark -
#pragma mark TTPostControllerDelegate
- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
	//validate if ok
	return YES;
}

- (void)postController: (TTPostController *)postController
           didPostText: (NSString *)texts
            withResult: (id)result {
	descriptionCell.customTextField.text = texts;
}

- (void)postControllerDidCancel:(TTPostController *)postController {
	NSLog(@"postControllerDidCancel");
}

@end
