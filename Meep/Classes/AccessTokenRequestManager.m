//
//  AccessTokenRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 14/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccessTokenRequestManager.h"

@implementation AccessTokenRequestManager

@synthesize accessToken;

- (id)initWithAccessToken:(NSString *)token {
	self.accessToken = token;
	return self;
}

- (void)dealloc {
	[accessToken release];
	[super dealloc];
}

@end
