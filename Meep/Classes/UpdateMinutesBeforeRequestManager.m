//
//  UpdateMinutesBeforeRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 16/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "UpdateMinutesBeforeRequestManager.h"

#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation UpdateMinutesBeforeRequestManager

@synthesize delegate;

- (void)updateMinutesBefore:(NSNumber *)minutes forMeeting:(MeetingDTO *)meeting {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"meetings/";
	NSString *resourceEnd = @"/minutes-before/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@%@", baseURL, resource, meeting._id, resourceEnd, fullQueryString];
	
	NSLog(@"URL of request: %@", fullURL);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	[request setRequestMethod:@"PUT"];
    [request appendPostData:[[minutes stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
	
	[super requestFinished:request];
	
	if ([request responseStatusCode] == 200) {
		[delegate updateMinutesBeforeSuccessful];
	} else {
		[delegate updateMinutesBeforeFailedWithError:[NSError errorWithDomain:[request responseString] 
                                                                    code:[request responseStatusCode] 
                                                                userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate updateMinutesBeforeFailedWithNetworkError:[request error]];
    }
}

@end
