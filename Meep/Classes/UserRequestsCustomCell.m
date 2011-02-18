//
//  UserRequestsCustomCell.m
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserRequestsCustomCell.h"

@implementation UserRequestsCustomCell

@synthesize customLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	// Overrides default behaviour
    //[super setSelected:selected animated:animated];
}

- (void)dealloc {
	[customLabel release];
	[super dealloc];
}

@end
