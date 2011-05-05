//
//  UserAnnotation.m
//  Meep
//
//  Created by Alex Jarvis on 14/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize updated;
@synthesize accuracyCircle;

- (void)dealloc {
    [title release];
    [subtitle release];
    [updated release];
    [accuracyCircle release];
    [super dealloc];
}

@end
