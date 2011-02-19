//
//  DeclineUserRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@class DeclineUserRequestManager;

@protocol DeclineUserRequestManagerDelegate <NSObject>

@required

- (void)declineUserSuccessful:(User *)user;

- (void)declineUserFailedWithError:(NSError *)error;

- (void)declineUserFailedWithNetworkError:(NSError *)error;

@end