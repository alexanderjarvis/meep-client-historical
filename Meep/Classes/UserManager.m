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
#import "UserDTO.h"

@implementation UserManager

@synthesize delegate;

- (void)getUser:(NSString *)userId {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"users/";
	
	NSString *queryString = @"?oauth_token=";
	NSString *fullQueryString = [queryString stringByAppendingString:accessToken];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@%@%@", baseURL, resource, userId, fullQueryString];
	
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
		
		UserDTO *emptyUser = [[UserDTO alloc] init];
		UserDTO *user = [DictionaryModelMapper createObject:emptyUser fromDictionary:[[request responseString] yajl_JSON]];
		[emptyUser release];
		
		// Declare SortDescriptor to sort the connections by first and last names ascending
		NSSortDescriptor *firstNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease];
		NSSortDescriptor *lastNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES] autorelease];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:firstNameDescriptor, lastNameDescriptor, nil];
		// Sort the users connections
        if (user.connections) {
            user.connections = [user.connections sortedArrayUsingDescriptors:sortDescriptors];
        }
		
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

@end
