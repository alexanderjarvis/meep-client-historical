//
//  NewMeetingBuilder.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMeetingBuilder.h"


@implementation NewMeetingBuilder

@synthesize meetingDTO;

static NewMeetingBuilder *sharedNewMeetingBuilder;

- (id)init {
	if (self == [super init]) {
		self.meetingDTO = [[MeetingDTO alloc] init];
	}
	return self;
}

+ (NewMeetingBuilder *)sharedNewMeetingBuilder {
	if (sharedNewMeetingBuilder == nil) {
        sharedNewMeetingBuilder = [[NewMeetingBuilder alloc] init];
		
    }
    return sharedNewMeetingBuilder;
}

- (void)dealloc {
	[meetingDTO release];
	[super dealloc];
}

@end
