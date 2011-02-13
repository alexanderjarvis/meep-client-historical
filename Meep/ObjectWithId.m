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

@end
