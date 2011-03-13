//
//  AccessTokenRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 14/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccessTokenRequestManager.h"

#import "MeepAppDelegate.h"

@implementation AccessTokenRequestManager

@synthesize accessToken;
@synthesize responseOk;

- (id)initWithAccessToken:(NSString *)token {
	self.accessToken = token;
	return self;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [super requestFinished:request];
    responseOk = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [super requestFailed:request];
    
    if ([request responseStatusCode] == 401) {
        responseOk = NO;
        [[MeepAppDelegate sharedAppDelegate] showWelcomeViewWithUnauthorisedMessage];
    } else {
        responseOk = YES;
    }
}

- (void)dealloc {
	[accessToken release];
	[super dealloc];
}

@end
