//
//  MeetingDetailCell.m
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingDetailCell.h"


@implementation MeetingDetailCell

@synthesize delegate;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize acceptedAmountLabel;
@synthesize declinedAmountLabel;
@synthesize awaitingReplyAmountLabel;
@synthesize attendingControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialisation code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // Override default behaviour
    //[super setSelected:selected animated:animated];
    
}

/*
 * Called whenever the value for the segmented control is changed.
 */
- (IBAction)attendingControlAction {

    NSInteger selectedIndex = attendingControl.selectedSegmentIndex;
    
    switch (selectedIndex) {
        case -1:
            // Not selected
            break;
        case 0:
            // Attending
            [delegate attendingButtonPressed];
            break;
        case 1:
            // Not attending
            [delegate notAttendingButtonPressed];
            break;
            
    }
}

- (void)dealloc {
    [titleLabel release];
	[dateLabel release];
	[timeLabel release];
	[acceptedAmountLabel release];
	[declinedAmountLabel release];
    [awaitingReplyAmountLabel release];
    [attendingControl release];
    [super dealloc];
}


@end
