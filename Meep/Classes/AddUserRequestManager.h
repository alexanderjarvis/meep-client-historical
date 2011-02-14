//
//  AddUserRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "AddUserRequestManagerDelegate.h"
#import "User.h"

@interface AddUserRequestManager : AccessTokenRequestManager {
	id <AddUserRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)addUserRequest:(User *)user;

@end
