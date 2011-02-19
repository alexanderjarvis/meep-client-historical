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

}

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end
