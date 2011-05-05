//
//  LoginManagerDelegate.h
//  meep
//
//  Created by Alex Jarvis on 20/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

@class LoginManager;

@protocol LoginManagerDelegate <NSObject>

@required

- (void)loginSuccessful;

- (void)loginFailedWithError:(NSError *)error;

- (void)loginFailedWithNetworkError:(NSError *)error;

@end
