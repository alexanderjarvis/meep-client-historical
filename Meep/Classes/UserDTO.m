//
//  User.m
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserDTO.h"

@implementation UserDTO

@synthesize _id;
@synthesize accessToken;
@synthesize email;
@synthesize password;
@synthesize firstName;
@synthesize lastName;
@synthesize mobileNumber;
@synthesize connections;
@synthesize _type_connections;
@synthesize connectionRequestsTo;
@synthesize _type_connectionRequestsTo;
@synthesize connectionRequestsFrom;
@synthesize _type_connectionRequestsFrom;
@synthesize meetingsRelated;
@synthesize _type_meetingsRelated;

- (id)init {
	if (self == [super init]) {
		connections = [[NSArray alloc] init];
		_type_connections = [[UserSummaryDTO alloc] init];
		connectionRequestsTo = [[NSArray alloc] init];
		_type_connectionRequestsTo = [[UserSummaryDTO alloc] init];
		connectionRequestsFrom = [[NSArray alloc] init];
		_type_connectionRequestsFrom = [[UserSummaryDTO alloc] init];
		meetingsRelated = [[NSArray alloc] init];
		_type_meetingsRelated = [[MeetingDTO alloc] init];
	}
	return self;
}

- (void)dealloc {
	[_id release];
	[accessToken release];
	[email release];
    [password release];
	[firstName release];
	[lastName release];
	[mobileNumber release];
	[connections release];
	[_type_connections release];
	[connectionRequestsTo release];
	[_type_connectionRequestsTo release];
	[connectionRequestsFrom release];
	[_type_connectionRequestsFrom release];
	[meetingsRelated release];
	[_type_meetingsRelated release];
	[super dealloc];
}

@end
