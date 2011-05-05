//
//  UpdateUserRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 04/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <YAJL/YAJL.h>

#import "UpdateUserRequestManager.h"

#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DictionaryModelMapper.h"

@implementation UpdateUserRequestManager

@synthesize delegate;

- (void)updateUser:(UserDTO *)user {
	
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
	
    NSString *body = [[DictionaryModelMapper createDictionaryWithObject:user] yajl_JSONString];
	NSLog(@"Request body: \n%@", body);
	[request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setRequestMethod:@"PUT"];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
	
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 200) {
		[delegate updateUserSuccessful];
	} else {
		[delegate updateUserFailedWithError:[NSError errorWithDomain:[request responseString] 
                                                                         code:[request responseStatusCode] 
                                                                     userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate updateUserFailedWithNetworkError:[request error]];
    }
}

@end