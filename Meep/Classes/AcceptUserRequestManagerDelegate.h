//
//  AcceptUserRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserDTO.h"

@class AcceptUserRequestManager;

@protocol AcceptUserRequestManagerDelegate <NSObject>

@required

- (void)acceptUserSuccessful:(UserSummaryDTO *)user;

- (void)acceptUserFailedWithError:(NSError *)error;

- (void)acceptUserFailedWithNetworkError:(NSError *)error;

@end