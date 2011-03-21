//
//  DeclineUserRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "DeclineUserRequestManagerDelegate.h"
#import "UserDTO.h"

#define userKey @"user"

@interface DeclineUserRequestManager : AccessTokenRequestManager {
	id <DeclineUserRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)declineUser:(UserSummaryDTO *)user;

@end