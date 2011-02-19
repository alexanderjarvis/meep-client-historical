//
//  RequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"Request failed with Error: %@", [[request error] localizedDescription]);
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
}

@end
