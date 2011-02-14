//
//  LoginManager.m
//  meep
//
//  Created by Alex Jarvis on 20/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginManager.h"

#import "ASIFormDataRequest.h"
#import <objc/runtime.h>

#import "MeepAppDelegate.h"

@implementation LoginManager

@synthesize delegate;

#pragma mark ASI request methods
- (void)loginUser:(UserDTO *)user {
	
	// Store the email
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[[meepAppDelegate configManager] setEmail: user.email];
	
	// Build up the URL
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *loginURL = @"oauth2";
	NSString *fullURL = [baseURL stringByAppendingString:loginURL];
	NSLog(@"URL of request: %@", fullURL);
	
	// Do the request
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	
	[request setPostValue:@"password" forKey:@"grant_type"];
	[request setPostValue:user.email forKey:@"client_id"];
	[request setPostValue:user.password forKey:@"client_secret"];
	
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
	
	if ([request responseStatusCode] == 200) {
		
		// Store the access token
		NSString *accessToken = responseString;
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[[meepAppDelegate configManager] setAccess_token: accessToken];
		
		[delegate loginSuccessful];
		
	} else {
		[delegate loginFailedWithError:
			[NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog(@"Request failed with Error: %@", [error localizedDescription]);
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
	
	[delegate loginFailedWithNetworkError:error];
}


@end
