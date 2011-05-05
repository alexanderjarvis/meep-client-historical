//
//  AttendeeDTO.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "AttendeeDTO.h"

@implementation AttendeeDTO

@synthesize _id;
@synthesize firstName;
@synthesize lastName;
@synthesize rsvp;
@synthesize minutesBefore;

- (void)dealloc {
	[_id release];
	[firstName release];
	[lastName release];
	[rsvp release];
    [minutesBefore release];
	[super dealloc];
}

@end
