//
//  MeetingsRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingDTO.h"

@class MeetingsRequestManager;

@protocol MeetingsRequestManagerDelegate <NSObject>

@required

- (void)getMeetingsSuccessful:(NSArray *)meetings;

- (void)getMeetingsFailedWithError:(NSError *)error;

- (void)getMeetingsFailedWithNetworkError:(NSError *)error;

@end