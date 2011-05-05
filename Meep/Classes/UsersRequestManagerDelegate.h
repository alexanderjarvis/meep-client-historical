//
//  UsersRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 02/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UsersRequestManager;

@protocol UsersRequestManagerDelegate <NSObject>

@required

- (void)getUsersSuccessful:(NSArray *)users;

- (void)getUsersFailedWithError:(NSError *)error;

- (void)getUsersFailedWithNetworkError:(NSError *)error;

@end