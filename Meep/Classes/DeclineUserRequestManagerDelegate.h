//
//  DeclineUserRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserDTO.h"

@class DeclineUserRequestManager;

@protocol DeclineUserRequestManagerDelegate <NSObject>

@required

- (void)declineUserSuccessful:(UserSummaryDTO *)user;

- (void)declineUserFailedWithError:(NSError *)error;

- (void)declineUserFailedWithNetworkError:(NSError *)error;

@end