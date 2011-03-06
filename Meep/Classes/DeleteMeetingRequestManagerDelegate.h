//
//  DeleteMeetingRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 06/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class DeleteMeetingRequestManager;

@protocol DeleteMeetingRequestManagerDelegate <NSObject>

@required

- (void)deleteMeetingSuccessful;

- (void)deleteMeetingFailedWithError:(NSError *)error;

- (void)deleteMeetingFailedWithNetworkError:(NSError *)error;

@end