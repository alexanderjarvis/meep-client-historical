//
//  UserDTO.m
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserDTO.h"


@implementation UserDTO

@synthesize email;
@synthesize password;
@synthesize firstName;
@synthesize lastName;
@synthesize mobileNumber;

- (void) dealloc {
	[email release];
	[password release];
	[firstName release];
	[lastName release];
	[mobileNumber release];
	[super dealloc];
}

@end
