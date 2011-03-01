//
//  CreateMeetingRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class CreateMeetingRequestManager;

@protocol CreateMeetingRequestManagerDelegate <NSObject>

@required

- (void)createMeetingSuccessful;

- (void)createMeetingFailedWithError:(NSError *)error;

- (void)createMeetingFailedWithNetworkError:(NSError *)error;

@end