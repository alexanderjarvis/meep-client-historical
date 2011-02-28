//
//  RegistrationManager.m
//  meep
//
//  Created by Alex Jarvis on 30/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <YAJL/YAJL.h>

#import "RegistrationManager.h"
#import "MeepAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "DictionaryModelMapper.h"

@implementation RegistrationManager

@synthesize delegate;

#pragma mark ASI request methods
- (void)registerUser:(UserDTO *)user {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *loginURL = @"users";
	NSString *fullURL = [baseURL stringByAppendingString:loginURL];
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	
	NSString *body = [[DictionaryModelMapper createDictionaryWithObject:user] yajl_JSONString];
	NSLog(@"Request body: \n%@", body);
	[request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[request setRequestMethod:@"POST"];
	
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 201) {
		
		NSDictionary *jsonDictionary = [[request responseString] yajl_JSON];
		NSLog(@"json dict: %@", jsonDictionary);
		
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[[meepAppDelegate configManager] setEmail:[jsonDictionary objectForKey:@"email"]];
		[[meepAppDelegate configManager] setAccess_token: [jsonDictionary objectForKey:@"accessToken"]];
		[[meepAppDelegate configManager] saveConfig];
		
		[delegate userRegistrationSuccessful];
		
	} else {
		[delegate userRegistrationFailedWithError:
			[NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
	[delegate userRegistrationFailedWithNetworkError:[request error]];
}


@end
