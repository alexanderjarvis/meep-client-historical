//
//  AttendeeDTO.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttendeeDTO.h"

@implementation AttendeeDTO

@synthesize _id;
@synthesize firstName;
@synthesize lastName;
@synthesize rsvp;

- (void)dealloc {
	[_id release];
	[firstName release];
	[lastName release];
	[rsvp release];
	[super dealloc];
}

@end
