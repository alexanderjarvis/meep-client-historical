//
//  User.m
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "UserSummary.h"

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

-(id)init {
	if (self == [super init]) {
		self.connections = [[NSArray alloc] init];
		self._type_connections = [[UserSummary alloc] init];
		self.connectionRequestsTo = [[NSArray alloc] init];
		self._type_connectionRequestsTo = [[UserSummary alloc] init];
		self.connectionRequestsFrom = [[NSArray alloc] init];
		self._type_connectionRequestsFrom = [[UserSummary alloc] init];
	}
	return self;
}

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
