//
//  LogoutManager.m
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "LogoutManager.h"

#import "MeepAppDelegate.h"

#import "ASIHTTPRequest.h"

@implementation LogoutManager

@synthesize delegate;

- (void)logoutUser {
    
    super.filterEnabled = NO;
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
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

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
	
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 200) {
		[delegate logoutUserSuccessful];
	} else {
		[delegate logoutUserFailedWithError:[NSError errorWithDomain:[request responseString] 
																code:[request responseStatusCode] 
															userInfo:nil]];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [super requestFailed:request];
    
    if ([request responseStatusCode] == 401) {
        // The user is already unauthorised
        [delegate logoutUserSuccessful];
    } else {
        [delegate logoutUserFailedWithNetworkError:[request error]];
    }
    
}

@end
