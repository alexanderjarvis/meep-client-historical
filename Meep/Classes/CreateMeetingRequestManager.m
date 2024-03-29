//
//  CreateMeetingRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//
#import <YAJL/YAJL.h>

#import "CreateMeetingRequestManager.h"
#import "MeepAppDelegate.h"
#import "DictionaryModelMapper.h"

@implementation CreateMeetingRequestManager

@synthesize delegate;

- (void)createMeeting:(MeetingDTO *)meeting {
		
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"meetings/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@", baseURL, resource, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	
	NSString *body = [[DictionaryModelMapper createDictionaryWithObject:meeting] yajl_JSONString];
	NSLog(@"Request body: \n%@", body);
	[request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[request setRequestMethod:@"POST"];
	
	[request startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
	
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 201) {
				
		[delegate createMeetingSuccessful];
		
	} else {
		[delegate createMeetingFailedWithError:
		 [NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate createMeetingFailedWithNetworkError:[request error]];
    }
}

@end
