//
//  MeetingPlaceAnnotation.m
//  Meep
//
//  Created by Alex Jarvis on 15/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "MeetingPlaceAnnotation.h"

@implementation MeetingPlaceAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize _id;

- (void)dealloc {
    [title release];
    [subtitle release];
    [_id release];
    [super dealloc];
}

@end
