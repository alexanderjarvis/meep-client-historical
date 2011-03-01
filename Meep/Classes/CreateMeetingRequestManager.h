//
//  CreateMeetingRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "CreateMeetingRequestManagerDelegate.h"
#import "MeetingDTO.h"

@interface CreateMeetingRequestManager : AccessTokenRequestManager {
	id <CreateMeetingRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)createMeeting:(MeetingDTO *)meeting;

@end
