//
//  CustomCellTextField.m
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCellTextField.h"

@implementation CustomCellTextField

@synthesize tableViewController;
@synthesize tableView;

@synthesize customTextLabel;
@synthesize customTextField;

@synthesize required;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Don't perform selections.
    //[super setSelected:selected animated:animated];
}

- (void)setRequired:(BOOL)newValue {
	if (newValue == YES) {
		customTextField.placeholder = @"required";
	} else {
        customTextField.placeholder = @"optional";
    }
	required = newValue;
}


- (void)dealloc {	
	[customTextLabel release];
	[customTextField release];
    [super dealloc];
}

#pragma mark UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [tableViewController tableView:tableView didSelectRowAtIndexPath:[tableView indexPathForCell:self]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[tableViewController textFieldCellReturned:self inTableView:tableView];
	return NO;
}

//TODO set delegate

@end
