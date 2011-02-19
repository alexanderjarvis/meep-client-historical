//
//  SearchUserManager.m
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchUsersManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DictionaryModelMapper.h"
#import "User.h"

@implementation SearchUsersManager

@synthesize delegate;

- (void)searchUsers:(NSString *)searchString {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *resource = @"search/users/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@", baseURL, resource, searchString, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	[super requestFinished:request];
	
	NSString *responseString = [request responseString];
	
	if ([request responseStatusCode] == 200) {
		
		NSArray *arrayOfUserDictionaries = [responseString yajl_JSON];
		
		User *emptyUser = [[User alloc] init];
		NSArray *arrayOfUsers = [DictionaryModelMapper createArrayOfObjects:emptyUser fromArrayOfDictionaries:arrayOfUserDictionaries];
		[delegate searchUsersSuccessful:arrayOfUsers];
		
	} else if ([request responseStatusCode] == 404) {
		[delegate searchUsersNotFound];
	} else {
		[delegate searchUsersFailedWithError:
		 [NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
}

- (void)dealloc {
	[super dealloc];
}

@end
