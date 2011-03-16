//
//  UpdateMinutesBeforeRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 16/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "UpdateMinutesBeforeRequestManagerDelegate.h"
#import "MeetingDTO.h"

@interface UpdateMinutesBeforeRequestManager : AccessTokenRequestManager {
    id <UpdateMinutesBeforeRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)updateMinutesBefore:(NSNumber *)minutes forMeeting:(MeetingDTO *)meeting;

@end
