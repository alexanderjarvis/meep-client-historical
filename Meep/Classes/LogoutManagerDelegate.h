//
//  LogoutManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 10/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

@class LogoutManager;

@protocol LogoutManagerDelegate <NSObject>

@required

- (void)logoutUserSuccessful;

- (void)logoutUserFailedWithError:(NSError *)error;

- (void)logoutUserFailedWithNetworkError:(NSError *)error;

@end