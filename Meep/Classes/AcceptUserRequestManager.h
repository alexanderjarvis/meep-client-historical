//
//  AcceptUserRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "AcceptUserRequestManagerDelegate.h"
#import "UserDTO.h"

#define userKey @"user"

@interface AcceptUserRequestManager : AccessTokenRequestManager {
	id <AcceptUserRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)acceptUser:(UserSummaryDTO *)user;

@end