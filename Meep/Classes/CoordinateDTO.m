//
//  CoordinateDTO.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "CoordinateDTO.h"


@implementation CoordinateDTO

@synthesize latitude;
@synthesize longitude;

- (void)dealloc {
	[latitude release];
	[longitude release];
	[super dealloc];
}

@end
