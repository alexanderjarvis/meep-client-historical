//
//  DeleteMeetingRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 06/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "DeleteMeetingRequestManagerDelegate.h"
#import "MeetingDTO.h"

@interface DeleteMeetingRequestManager : AccessTokenRequestManager {
    
	id <DeleteMeetingRequestManagerDelegate> delegate;
    
}

@property (assign, nonatomic) id delegate;

- (void)deleteMeeting:(MeetingDTO *)meeting;

@end
