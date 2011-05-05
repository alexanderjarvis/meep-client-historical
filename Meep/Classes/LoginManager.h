//
//  LoginManager.h
//  meep
//
//  Created by Alex Jarvis on 20/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestManager.h"
#import "LoginManagerDelegate.h"
#import "UserDTO.h"

@interface LoginManager : RequestManager {
	
	id <LoginManagerDelegate> delegate;

}

@property (assign, nonatomic) id delegate;

- (void)loginUser:(UserDTO *)user;

@end
