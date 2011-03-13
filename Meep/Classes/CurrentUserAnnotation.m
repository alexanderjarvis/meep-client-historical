//
//  CurrentUserAnnotation.m
//  Meep
//
//  Created by Alex Jarvis on 13/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentUserAnnotation.h"

@implementation CurrentUserAnnotation

@synthesize coordinate;
@synthesize title;

- (void)dealloc {
    [title release];
    [super dealloc];
}

@end
