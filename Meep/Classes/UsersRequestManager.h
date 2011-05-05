//
//  UsersRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 02/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "UsersRequestManagerDelegate.h"

@interface UsersRequestManager : AccessTokenRequestManager {
    id <UsersRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)getUsers;

@end