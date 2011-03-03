//
//  MeetingCell.m
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingCell.h"


@implementation MeetingCell

@synthesize titleLabel;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize acceptedAmountLabel;
@synthesize declinedAmountLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[titleLabel release];
	[dateLabel release];
	[timeLabel release];
	[acceptedAmountLabel release];
	[declinedAmountLabel release];
    [super dealloc];
}


@end
