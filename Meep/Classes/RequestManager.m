//
//  RequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestManager.h"

#import "Reachability.h"

@implementation RequestManager

@synthesize responseString;
@synthesize previousResponseString;

- (void)dealloc {
    [previousRequest release];
	[responseString release];
	[previousResponseString release];
	[super dealloc];
}

- (BOOL)isResponseNew {
	return ![responseString isEqualToString:previousResponseString];
}

- (void)retryPreviousRequest {
    // If no connection to the internet
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [self requestFailed:previousRequest];
        return;
    }
    NSLog(@"Retrying previous request: %@", [previousRequest url]);
    BOOL retrying = [previousRequest retryUsingNewConnection];
    if (!retrying) {
        [self requestFailed:previousRequest];
    }
}

#pragma mark -
#pragma mark ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request {
    previousRequest = [request retain];
    
	self.previousResponseString = responseString;
	self.responseString = [request responseString];
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    previousRequest = [request retain];
    
	NSLog(@"Request failed with Error: %@", [[request error] localizedDescription]);
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
}

@end
