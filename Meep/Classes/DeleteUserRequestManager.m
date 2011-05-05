//
//  DeleteUserRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 02/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "DeleteUserRequestManager.h"

#import "MeepAppDelegate.h"

@implementation DeleteUserRequestManager

@synthesize delegate;

- (void)deleteUser:(UserDTO *)user; {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"users/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@", baseURL, resource, user._id, fullQueryString];
	
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
		[delegate deleteUserSuccessful];
	} else {
		[delegate deleteUserFailedWithError:[NSError errorWithDomain:[request responseString] 
                                                                code:[request responseStatusCode] 
                                                            userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate deleteUserFailedWithNetworkError:[request error]];
    }
}

@end
