//
//  UpdateUserRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 04/04/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserDTO.h"

@class UpdateUserRequestManager;

@protocol UpdateUserRequestManagerDelegate <NSObject>

@required

- (void)updateUserSuccessful;

- (void)updateUserFailedWithError:(NSError *)error;

- (void)updateUserFailedWithNetworkError:(NSError *)error;

@end