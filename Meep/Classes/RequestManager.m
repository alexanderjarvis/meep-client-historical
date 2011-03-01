//
//  RequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

@synthesize responseString;
@synthesize previousResponseString;

- (void)requestFinished:(ASIHTTPRequest *)request {
	self.previousResponseString = responseString;
	self.responseString = [request responseString];
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"Request failed with Error: %@", [[request error] localizedDescription]);
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
}

- (BOOL)isResponseSameAsPreviousRequest {
	return [responseString isEqualToString:previousResponseString];
}

- (void)dealloc {
	[responseString release];
	[previousResponseString release];
	[super dealloc];
}

@end
