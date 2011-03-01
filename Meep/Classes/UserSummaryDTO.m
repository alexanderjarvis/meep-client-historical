//
//  UserSummaryDTO.m
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserSummaryDTO.h"


@implementation UserSummaryDTO

@synthesize _id;
@synthesize email;
@synthesize firstName;
@synthesize lastName;
@synthesize mobileNumber;

- (void) dealloc {
	[_id release];
	[email release];
	[firstName release];
	[lastName release];
	[mobileNumber release];
	[super dealloc];
}

@end
