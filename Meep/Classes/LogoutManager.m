//
//  LogoutManager.m
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogoutManager.h"

#import "MeepAppDelegate.h"

#import <objc/runtime.h>
#import "ASIHTTPRequest.h"

@implementation LogoutManager

@synthesize delegate;
@synthesize accessToken;

- (id)initWithAccessToken:(NSString *)accessToken {
	self.accessToken = accessToken;
	return self;
}

- (void)logoutUser {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *resource = @"oauth2/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@", baseURL, resource, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request setRequestMethod:@"DELETE"];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	NSString *responseString = [request responseString];
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);
	
	if ([request responseStatusCode] == 200) {
		[delegate logoutUserSuccessful];
	} else {
		[delegate logoutUserFailedWithError:
		 [NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	
	NSError *error = [request error];
	
	NSLog([error localizedDescription]);
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);
	
	[delegate logoutUserFailedWithNetworkError:error];
}

- (void)dealloc {
	[accessToken release];
	[super dealloc];
}

@end
