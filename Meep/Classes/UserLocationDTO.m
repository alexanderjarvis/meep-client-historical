//
//  UserLocationDTO.m
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLocationDTO.h"

@implementation UserLocationDTO

@synthesize time;
@synthesize coordinate;
@synthesize speed;
@synthesize altitude;
@synthesize trueHeading;
@synthesize verticalAccuracy;
@synthesize horizonalAccuracy;

- (id)init {
    self = [super init];
	if (self) {
		coordinate = [[CoordinateDTO alloc] init];
    }
    return self;
}

- (void)dealloc {
    [time release];
    [coordinate release];
    [speed release];
    [altitude release];
    [trueHeading release];
    [verticalAccuracy release];
    [horizontalAccuracy release];
    [super dealloc];
}

@end
