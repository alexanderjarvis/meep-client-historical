//
//  DeleteUserRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 03/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeleteUserRequestManager;

@protocol DeleteUserRequestManagerDelegate <NSObject>

@required

- (void)deleteUserSuccessful;

- (void)deleteUserFailedWithError:(NSError *)error;

- (void)deleteUserFailedWithNetworkError:(NSError *)error;

@end