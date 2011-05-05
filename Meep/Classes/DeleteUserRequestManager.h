//
//  DeleteUserRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 02/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "DeleteUserRequestManagerDelegate.h"
#import "UserDTO.h"

@interface DeleteUserRequestManager : AccessTokenRequestManager {
    
	id <DeleteUserRequestManagerDelegate> delegate;
    
}

@property (assign, nonatomic) id delegate;

- (void)deleteUser:(UserDTO *)user;

@end
