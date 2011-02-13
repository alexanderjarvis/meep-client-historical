//
//  AddUserRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class AddUserRequestManager;

@protocol AddUserRequestManagerDelegate <NSObject>

@required

- (void)addUserRequestSuccessful;

- (void)addUserRequestFailedWithError:(NSError *)error;

- (void)addUserRequestFailedWithNetworkError:(NSError *)error;

@end