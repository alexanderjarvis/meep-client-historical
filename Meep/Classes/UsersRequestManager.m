//
//  UsersRequestManager.m
//  Meep
//
//  Created by Alex Jarvis on 02/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <YAJL/YAJL.h>

#import "UsersRequestManager.h"
#import "MeepAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DictionaryModelMapper.h"
#import "UserDTO.h"

@implementation UsersRequestManager

@synthesize delegate;

- (void)getUsers {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] serviceUrl];
	NSString *resource = @"users/";
	
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
        
		NSArray *arrayOfUserDictionaries = [[request responseString] yajl_JSON];
		
		UserDTO *emptyUserDTO = [[UserDTO alloc] init];
		NSArray *arrayOfUserDTOs = [DictionaryModelMapper createArrayOfObjects:emptyUserDTO fromArrayOfDictionaries:arrayOfUserDictionaries];
		[emptyUserDTO release];
		
		// Declare SortDescriptor to sort the connections by first and last names ascending
		NSSortDescriptor *firstNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease];
		NSSortDescriptor *lastNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES] autorelease];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:firstNameDescriptor, lastNameDescriptor, nil];
        
		// Sort the users connections
        arrayOfUserDTOs = [arrayOfUserDTOs sortedArrayUsingDescriptors:sortDescriptors];
        
        [delegate getUsersSuccessful:arrayOfUserDTOs];
		
	} else {
		[delegate getUsersFailedWithError:
		 [NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[super requestFailed:request];
    
    if (responseOk) {
        [delegate getUsersFailedWithNetworkError:[request error]];
    }
}


@end
