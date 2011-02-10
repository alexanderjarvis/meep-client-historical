//
//  LogoutManager.h
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LogoutManagerDelegate.h"

@interface LogoutManager : NSObject {
	
	id <LogoutManagerDelegate> delegate;
	NSString *accessToken;

}

@property (assign, nonatomic) id delegate;
@property (nonatomic, copy) NSString *accessToken;

- (void)logoutUser;
- (id)initWithAccessToken:(NSString *)accessToken;

@end
