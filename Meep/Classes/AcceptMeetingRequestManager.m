//
//  AcceptMeetingRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 05/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AcceptMeetingRequestManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation AcceptMeetingRequestManager

@synthesize delegate;

- (void)acceptMeeting:(MeetingDTO *)meeting {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"meetings/";
	NSString *resourceEnd = @"/accept";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@%@", baseURL, resource, meeting._id, resourceEnd, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request setRequestMethod:@"POST"];
	[request setUserInfo:[NSDictionary dictionaryWithObject:meeting forKey:meetingKey]];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
	
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 200) {
		[delegate acceptMeetingSuccessful:[[request userInfo] objectForKey:meetingKey]];
	} else {
		[delegate acceptMeetingFailedWithError:[NSError errorWithDomain:[request responseString] 
																code:[request responseStatusCode] 
															userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate acceptMeetingFailedWithNetworkError:[request error]];
    }
}

@end