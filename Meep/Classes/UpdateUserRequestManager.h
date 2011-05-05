//
//  UpdateUserRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 04/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "UpdateUserRequestManagerDelegate.h"
#import "UserDTO.h"

@interface UpdateUserRequestManager : AccessTokenRequestManager {
    id <UpdateUserRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)updateUser:(UserDTO *)user;

@end
