//
//  LogoutManager.h
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "LogoutManagerDelegate.h"

@interface LogoutManager : AccessTokenRequestManager {
	
	id <LogoutManagerDelegate> delegate;

}

@property (assign, nonatomic) id delegate;

- (void)logoutUser;

@end
