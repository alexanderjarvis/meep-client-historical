//
//  ObjectWithId.m
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectWithId.h"


@implementation ObjectWithId

@synthesize _id;

- (void) dealloc {
	[_id release];
	[super dealloc];
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
	
	ObjectWithId *copy = [[[self class] allocWithZone:zone] init];
	copy._id = [self._id copy];
	
	return copy;
}

@end
