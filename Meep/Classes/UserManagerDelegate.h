//
//  UserManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@class UserManager;

@protocol UserManagerDelegate <NSObject>

@required

- (void)getUserSuccessful:(User *)user;

- (void)getUserFailedWithError:(NSError *)error;

- (void)getUserFailedWithNetworkError:(NSError *)error;

@end