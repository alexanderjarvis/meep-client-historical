//
//  RequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

@interface RequestManager : NSObject {
	
	NSString *responseString;
	NSString *previousResponseString;
}

@property(nonatomic, copy) NSString *responseString;
@property(nonatomic, copy) NSString *previousResponseString;

- (BOOL)isResponseNew;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end
