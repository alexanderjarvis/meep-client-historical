//
//  UpdateMinutesBeforeRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 16/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MeetingDTO.h"

@class UpdateMinutesBeforeRequestManager;

@protocol UpdateMinutesBeforeRequestManagerDelegate <NSObject>

@required

- (void)updateMinutesBeforeSuccessful;

- (void)updateMinutesBeforeFailedWithError:(NSError *)error;

- (void)updateMinutesBeforeFailedWithNetworkError:(NSError *)error;

@end