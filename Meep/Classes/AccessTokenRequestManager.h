//
//  AccessTokenRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 14/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestManager.h"

@interface AccessTokenRequestManager : RequestManager {

	NSString *accessToken;
    BOOL responseOk;
    BOOL filterEnabled;

}

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, assign) BOOL responseOk;
@property (nonatomic, assign) BOOL filterEnabled;

- (id)initWithAccessToken:(NSString *)token;

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end