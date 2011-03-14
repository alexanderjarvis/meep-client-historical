//
//  RecentUserLocationsDTO.m
//  Meep
//
//  Created by Alex Jarvis on 14/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecentUserLocationsDTO.h"


@implementation RecentUserLocationsDTO

@synthesize _id;
@synthesize firstName;
@synthesize lastName;
@synthesize locationHistory;
@synthesize _type_locationHistory;

- (id)init {
    self = [super init];
    if (self) {
        locationHistory = [[NSArray alloc] init];
        _type_locationHistory = [[UserLocationDTO alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_id release];
    [firstName release];
    [lastName release];
    [locationHistory release];
    [_type_locationHistory release];
    [super dealloc];
}

@end
