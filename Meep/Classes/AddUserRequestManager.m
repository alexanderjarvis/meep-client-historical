//
//  AddUserRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddUserRequestManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation AddUserRequestManager

@synthesize delegate;
@synthesize accessToken;

- (id)initWithAccessToken:(NSString *)accessToken {
	self.accessToken = accessToken;
	return self;
}

- (void)addUserRequest:(User *)user {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *resource = @"users/";
	NSString *resourceEnd = @"/add";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@%@", baseURL, resource, user._id, resourceEnd, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request setRequestMethod:@"POST"];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	NSString *responseString = [request responseString];
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
	
	if ([request responseStatusCode] == 200) {
		[delegate addUserRequestSuccessful];
	} else {
		[delegate addUserRequestFailedWithError:
		 [NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog(@"Request failed with Error: %@", [error localizedDescription]);
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
}


- (void)dealloc {
	[accessToken release];
	[super dealloc];
}


@end
