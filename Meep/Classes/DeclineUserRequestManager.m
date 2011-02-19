//
//  DeclineUserRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeclineUserRequestManager.h"

#import "AcceptUserRequestManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation DeclineUserRequestManager

@synthesize delegate;

- (void)declineUser:(User *)user {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *resource = @"users/";
	NSString *resourceEnd = @"/decline";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@%@", baseURL, resource, user._id, resourceEnd, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request setRequestMethod:@"POST"];
	[request setUserInfo:[NSDictionary dictionaryWithObject:user forKey:userKey]];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	NSString *responseString = [request responseString];
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
	
	if ([request responseStatusCode] == 200) {
		
		[delegate declineUserSuccessful:[[request userInfo] objectForKey:userKey]];
	} else {
		[delegate declineUserFailedWithError:
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
	[super dealloc];
}

@end
