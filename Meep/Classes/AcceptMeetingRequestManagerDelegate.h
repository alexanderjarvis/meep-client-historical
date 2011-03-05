//
//  AcceptMeetingRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 05/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingDTO.h"

@class AcceptMeetingRequestManager;

@protocol AcceptMeetingRequestManagerDelegate <NSObject>

@required

- (void)acceptMeetingSuccessful:(MeetingDTO *)meeting;

- (void)acceptMeetingFailedWithError:(NSError *)error;

- (void)acceptMeetingFailedWithNetworkError:(NSError *)error;

@end