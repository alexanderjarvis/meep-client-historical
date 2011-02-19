//
//  UserManager.m
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DictionaryModelMapper.h"
#import "User.h"

@implementation UserManager

@synthesize delegate;

- (void)getUser:(NSString *)userid {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *resource = @"users/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@", baseURL, resource, userid, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	[super requestFinished:request];
	
	NSString *responseString = [request responseString];
	
	if ([request responseStatusCode] == 200) {
		
		User *emptyUser = [[User alloc] init];
		User *user = [DictionaryModelMapper createObject:emptyUser fromDictionary:[responseString yajl_JSON]];
		[emptyUser release];
		
		[delegate getUserSuccessful:user];
		
	} else {
		[delegate getUserFailedWithError:
		 [NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
	[delegate getUserFailedWithNetworkError:[request error]];
}

- (void)dealloc {
	[super dealloc];
}

@end
