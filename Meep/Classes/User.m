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
@synthesize _type_connections;
@synthesize connectionRequestsTo;
@synthesize _type_connectionRequestsTo;
@synthesize connectionRequestsFrom;
@synthesize _type_connectionRequestsFrom;

- (void) dealloc {
	[_id release];
	[accessToken release];
	[email release];
	[firstName release];
	[lastName release];
	[mobileNumber release];
	[connections release];
	[_type_connections release];
	[connectionRequestsTo release];
	[_type_connectionRequestsTo release];
	[connectionRequestsFrom release];
	[_type_connectionRequestsFrom release];
	[super dealloc];
}

@end
