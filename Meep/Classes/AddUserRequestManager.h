//
//  AddUserRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddUserRequestManagerDelegate.h"
#import "User.h"

@interface AddUserRequestManager : NSObject {
	id <AddUserRequestManagerDelegate> delegate;
	
	NSString *accessToken;
}

@property (assign, nonatomic) id delegate;
@property (nonatomic, copy) NSString *accessToken;

- (id)initWithAccessToken:(NSString *)accessToken;
- (void)addUserRequest:(User *)user;

@end
