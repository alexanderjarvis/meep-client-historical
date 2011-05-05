//
//  RegistrationManagerDelegate.h
//  meep
//
//  Created by Alex Jarvis on 20/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

@class RegistrationManager;

@protocol RegistrationManagerDelegate <NSObject>

@required

- (void)userRegistrationSuccessful;

- (void)userRegistrationFailedWithError:(NSError *)error;

- (void)userRegistrationFailedWithNetworkError:(NSError *)error;

@end
