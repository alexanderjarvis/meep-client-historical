//
//  ObjectWithProperties.m
//  Meep
//
//  Created by Alex Jarvis on 27/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "ObjectWithProperties.h"

@implementation ObjectWithProperties

@synthesize _id;
@synthesize firstName;
@synthesize lastName;

- (void)dealloc {
	[_id release];
	[firstName release];
	[lastName release];
	[super dealloc];
}

@end
