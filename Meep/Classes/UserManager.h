//
//  UserManager.h
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserManagerDelegate.h"

@interface UserManager : NSObject {
	
	id <UserManagerDelegate> delegate;
	
	NSString *accessToken;
	
}

@property (assign, nonatomic) id delegate;
@property (nonatomic, copy) NSString *accessToken;

- (id)initWithAccessToken:(NSString *)accessToken;
- (void)getUser:(NSString *)userid;

@end
