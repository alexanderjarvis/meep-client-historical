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
	NSURL *url = [NSURL URLWithString:@"http://localhost:9000/oauth2"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setDelegate:self];
	
	// Set query string attributes
	[request setPostValue:@"password" forKey:@"grant_type"];
	[request setPostValue:user.email forKey:@"client_id"];
	[request setPostValue:user.password forKey:@"client_secret"];
	
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);;
	
	if ([request responseStatusCode] == 200) {
		//[delegate userRegistrationSuccessful];
		
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[meepAppDelegate showMenuView];
		
	} else {
		[delegate userRegistrationFailedWithError:
			[NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog([error localizedDescription]);
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);
	
	[delegate userRegistrationFailedWithNetworkError:error];
}


@end
