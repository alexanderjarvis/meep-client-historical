//
//  CustomCellTextField.m
//  Minutes
//
//  Created by Alex Jarvis on 10/01/2010.
//  Copyright 2010 AppSoup. All rights reserved.
//

#import "CustomCellTextField.h"


@implementation CustomCellTextField

@synthesize customTextLabel;
@synthesize customTextField;

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


- (void)dealloc {
	//[customTextLabel release];
	//[customTextField release];
    [super dealloc];
}


@end
