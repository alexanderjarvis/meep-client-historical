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

    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequired:(BOOL)newValue {
	if (newValue == YES) {
		customTextField.placeholder = @"required";
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
	[tableViewController textFieldCell:textField returnInTableView:tableView];
	return NO;
}

@end
