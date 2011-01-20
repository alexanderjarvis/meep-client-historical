//
//  RegistrationManager.m
//  meep
//
//  Created by Alex Jarvis on 30/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegistrationManager.h"

#import "ASIFormDataRequest.h"
#import <objc/runtime.h>

#import "MeepAppDelegate.h"

@implementation RegistrationManager

@synthesize delegate;

#pragma mark ASI request methods
- (void)registerUser:(UserDTO *)user {
	NSURL *url = [NSURL URLWithString:@"http://localhost:9000/users"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
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
		[request setPostValue:value forKey:key];
	}
	
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);;
	
	if ([request responseStatusCode] == 201) {
		[delegate userRegistrationSuccessful];
		
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[meepAppDelegate showMenuView];
		
	} else {
		[delegate userRegistrationFailedWithError:
			[NSError errorWithDomain:[request responseString] code:[request responseStatusCode] userInfo:nil]];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog([error localizedDescription]);
	
	NSLog([NSString stringWithFormat:@"Response status code: %d", [request responseStatusCode]]);
	NSLog([NSString stringWithFormat:@"Response: %@", [request responseString]]);
	
	[delegate userRegistrationFailedWithNetworkError:error];
}


@end
