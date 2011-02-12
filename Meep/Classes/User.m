//
//  User.m
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize _id;
@synthesize accessToken;
@synthesize email;
@synthesize firstName;
@synthesize lastName;
@synthesize mobileNumber;
@synthesize connections;

- (void) dealloc {
	[_id release];
	[accessToken release];
	[email release];
	[firstName release];
	[lastName release];
	[mobileNumber release];
	[connections release];
	[super dealloc];
}

@end
