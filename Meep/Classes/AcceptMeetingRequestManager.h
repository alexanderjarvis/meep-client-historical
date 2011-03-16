//
//  AcceptMeetingRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 05/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "AcceptMeetingRequestManagerDelegate.h"
#import "MeetingDTO.h"

@interface AcceptMeetingRequestManager : AccessTokenRequestManager {
	id <AcceptMeetingRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)acceptMeeting:(MeetingDTO *)meeting;

@end