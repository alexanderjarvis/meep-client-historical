//
//  AccessTokenRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 14/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestManager.h"

@interface AccessTokenRequestManager : RequestManager {

	NSString *accessToken;
    BOOL responseOk;

}

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, assign) BOOL responseOk;

- (id)initWithAccessToken:(NSString *)token;

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end