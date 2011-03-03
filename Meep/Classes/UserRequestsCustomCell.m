//
//  UserRequestsCustomCell.m
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>

#import "UserRequestsCustomCell.h"

@implementation UserRequestsCustomCell

@synthesize userRequestsViewController;
@synthesize indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		// Respond button
		TTButton *respondButton = [TTButton buttonWithStyle:@"toolbarButton:" title:@"Respond"];
		[respondButton sizeToFit];
		[respondButton addTarget:self action:@selector(respondButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		self.accessoryView = respondButton;
    }
    return self;
}

-(void)respondButtonPressed {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Respond to Friend Request" 
						  message:nil
						  delegate:self 
						  cancelButtonTitle:@"Cancel" 
						  otherButtonTitles:@"Accept", @"Decline", nil];
	[alert show];
	[alert release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	// Overrides default behaviour
    //[super setSelected:selected animated:animated];
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			// Cancel
			break;
		case 1:
			// Accept
			[userRequestsViewController acceptUserAtIndexPath:indexPath];
			break;
		case 2:
			// Decline
			[userRequestsViewController declineUserAtIndexPath:indexPath];
			break;
		default:
			break;
	}
}


@end
