//
//  AcceptUserRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "AcceptUserRequestManagerDelegate.h"
#import "User.h"

@interface AcceptUserRequestManager : AccessTokenRequestManager {
	id <AcceptUserRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)acceptUser:(User *)user;

@end