//
//  DeleteMeetingRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 06/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeleteMeetingRequestManager.h"

#import "MeepAppDelegate.h"

@implementation DeleteMeetingRequestManager

@synthesize delegate;

- (void)deleteMeeting:(MeetingDTO *)meeting {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"meetings/";;
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@", baseURL, resource, meeting._id, fullQueryString];
	
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
		[delegate deleteMeetingSuccessful];
	} else {
		[delegate deleteMeetingFailedWithError:[NSError errorWithDomain:[request responseString] 
																 code:[request responseStatusCode] 
															 userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate deleteMeetingFailedWithNetworkError:[request error]];
    }
}


@end
