//
//  MeetingsRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingsRequestManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DictionaryModelMapper.h"
#import "MeetingDTO.h"

@implementation MeetingsRequestManager

@synthesize delegate;

- (void)getMeetings {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *resource = @"meetings/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
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
		
		NSArray *arrayOfMeetingDictionaries = [[request responseString] yajl_JSON];
		
		MeetingDTO *emptyMeetingDTO = [[MeetingDTO alloc] init];
		NSArray *arrayOfMeetingDTOs = [DictionaryModelMapper createArrayOfObjects:emptyMeetingDTO fromArrayOfDictionaries:arrayOfMeetingDictionaries];
		[emptyMeetingDTO release];
		
		[delegate getMeetingsSuccessful:arrayOfMeetingDTOs];
		
	} else {
		[delegate getMeetingsFailedWithError:
		 [NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
	[delegate getMeetingsFailedWithNetworkError:[request error]];
}

@end