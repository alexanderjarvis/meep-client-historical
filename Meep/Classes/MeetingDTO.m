//
//  MeetingDTO.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingDTO.h"

@implementation MeetingDTO

@synthesize _id;
@synthesize time;
@synthesize place;
@synthesize attendees;
@synthesize _type_attendees;
@synthesize owner;
@synthesize title;
@synthesize description;

-(id)init {
	if (self == [super init]) {
		self.place = [[CoordinateDTO alloc] init];
		self.attendees = [[NSArray alloc] init];
		self._type_attendees = [[AttendeeDTO alloc] init];
		self.owner = [[UserSummaryDTO alloc] init];
	}
	return self;
}

- (void) dealloc {
	[_id release];
	[time release];
	[place release];
	[attendees release];
	[_type_attendees release];
	[owner release];
	[title release];
	[description release];
	[super dealloc];
}

@end