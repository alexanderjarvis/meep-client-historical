//
//  OtherUserAnnotation.m
//  Meep
//
//  Created by Alex Jarvis on 14/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "OtherUserAnnotation.h"


@implementation OtherUserAnnotation

@synthesize _id;
@synthesize locationHistory;

- (void)dealloc {
    [_id release];
    [super dealloc];
}

@end