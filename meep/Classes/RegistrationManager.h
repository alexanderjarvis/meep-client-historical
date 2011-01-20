//
//  RegistrationManager.h
//  meep
//
//  Created by Alex Jarvis on 30/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RegistrationManagerDelegate.h"
#import "UserDTO.h"

@interface RegistrationManager : NSObject {
	
	id <RegistrationManagerDelegate> delegate;

}

@property (assign, nonatomic) id delegate;

- (void)registerUser:(UserDTO *)user;

@end
