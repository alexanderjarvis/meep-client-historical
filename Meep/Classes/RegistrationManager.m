//
//  RegistrationManager.m
//  meep
//
//  Created by Alex Jarvis on 30/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegistrationManager.h"

#import "MeepAppDelegate.h"

#import "ASIFormDataRequest.h"
#import <objc/runtime.h>

#import <YAJL/YAJL.h>

@implementation RegistrationManager

@synthesize delegate;

#pragma mark ASI request methods
- (void)registerUser:(UserDTO *)user {
	
	// Build up the URL
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	NSString *baseURL = [[meepAppDelegate configManager] url];
	NSString *loginURL = @"users";
	NSString *fullURL = [baseURL stringByAppendingString:loginURL];
	NSLog(@"URL of request: %@", fullURL);
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
	[request setDelegate:self];
	
	// TODO move to another class and method
	// Get properties for class
	Class clazz = [user class];
    u_int count;
	
    objc_property_t * properties = class_copyPropertyList(clazz, &count);
    NSMutableArray * propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
	
	// Add properties to request
	for (int i = 0; i < [propertyArray count]; i++) {
		NSString *key = [NSString stringWithFormat:@"user.%@", [propertyArray objectAtIndex:i]];
		NSString *value = [user valueForKey:[propertyArray objectAtIndex:i]];
		if (value != nil) {
			[request setPostValue:value forKey:key];
		}
	}
	
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
	
	if ([request responseStatusCode] == 201) {
		
		NSDictionary *jsonDictionary = [[request responseString] yajl_JSON];
		NSLog(@"json dict: %@", jsonDictionary);
		
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[[meepAppDelegate configManager] setEmail:[jsonDictionary objectForKey:@"email"]];
		[[meepAppDelegate configManager] setAccess_token: [jsonDictionary objectForKey:@"accessToken"]];
		[[meepAppDelegate configManager] saveConfig];
		
		[delegate userRegistrationSuccessful];
		
	} else {
		[delegate userRegistrationFailedWithError:
			[NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog(@"Request failed with Error: %@", [error localizedDescription]);
	
	NSLog(@"Response status code: %d", [request responseStatusCode]);
	NSLog(@"Response: %@", [request responseString]);
	
	[delegate userRegistrationFailedWithNetworkError:error];
}


@end
