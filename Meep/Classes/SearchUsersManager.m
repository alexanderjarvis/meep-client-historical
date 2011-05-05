//
//  SearchUserManager.m
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//
#import <YAJL/YAJL.h>

#import "SearchUsersManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DictionaryModelMapper.h"
#import "UserDTO.h"

@implementation SearchUsersManager

@synthesize delegate;

- (void)searchUsers:(NSString *)searchString {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"search/users/";
	
	NSString *searchParam = @"query";
	NSString *oauthParam = @"oauth_token";
	NSString *fullQueryString = [NSString stringWithFormat:@"?%@=%@&%@=%@", 
								 searchParam, 
								 [searchString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], 
								 oauthParam, 
								 accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@", baseURL, resource, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 200) {
		
		NSArray *arrayOfUserDictionaries = [[request responseString] yajl_JSON];
		
		UserDTO *emptyUser = [[UserDTO alloc] init];
		NSArray *arrayOfUsers = [DictionaryModelMapper createArrayOfObjects:emptyUser fromArrayOfDictionaries:arrayOfUserDictionaries];
        [emptyUser release];
		[delegate searchUsersSuccessful:arrayOfUsers];
		
	} else if ([request responseStatusCode] == 404) {
		[delegate searchUsersNotFound];
	} else {
		[delegate searchUsersFailedWithError:[NSError errorWithDomain:[request responseString] 
																 code:[request responseStatusCode]
															 userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate searchUsersFailedWithNetworkError:[request error]];
    }
}

@end
