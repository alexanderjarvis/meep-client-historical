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

@synthesize datePicker;

- (void)viewDidLoad {
	
	self.title = @"Date & Time";
	
    [super viewDidLoad];
}

- (IBAction)choosePeople {
	NSLog(@"Choose People button pressed");
	
	// do something with date
	[datePicker date];
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[meepAppDelegate.menuNavigationController showNewMeetingPeople];
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


- (void)dealloc {
	[datePicker release];
    [super dealloc];
}


@end
