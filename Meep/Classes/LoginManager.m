//
//  LoginManager.m
//  meep
//
//  Created by Alex Jarvis on 20/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "LoginManager.h"

#import "ASIFormDataRequest.h"

#import "MeepAppDelegate.h"

@implementation LoginManager

@synthesize delegate;

- (void)loginUser:(UserDTO *)user {
	
	// Store the email
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	[[meepAppDelegate configManager] setEmail: user.email];
	
	// Build up the URL
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
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

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
	
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 200) {
		
		// Store the access token
		NSString *accessToken = responseString;
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[[meepAppDelegate configManager] setAccessToken: accessToken];
        [[meepAppDelegate configManager] saveConfig];
		
		[delegate loginSuccessful];
		
	} else {
		[delegate loginFailedWithError:[NSError errorWithDomain:[request responseString] 
														   code:[request responseStatusCode] 
													   userInfo:nil]];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    [delegate loginFailedWithNetworkError:[request error]];
}


@end
