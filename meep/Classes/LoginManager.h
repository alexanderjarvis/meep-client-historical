//
//  LoginManager.h
//  meep
//
//  Created by Alex Jarvis on 20/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoginManagerDelegate.h"
#import "UserDTO.h"

@interface LoginManager : NSObject {
	
	id <LoginManagerDelegate> delegate;

}

@property (assign, nonatomic) id delegate;

- (void)loginUser:(UserDTO *)user;

@end