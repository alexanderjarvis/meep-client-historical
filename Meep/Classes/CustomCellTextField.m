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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
	[tableViewController release];
	[tableView release];
	
	[customTextLabel release];
	[customTextField release];
    [super dealloc];
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[tableViewController textFieldCell:self returnInTableView:tableView];
	return NO;
}


@end
