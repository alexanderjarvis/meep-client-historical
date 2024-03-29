//
//  DeclineMeetingRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 05/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "DeclineMeetingRequestManagerDelegate.h"
#import "MeetingDTO.h"

@interface DeclineMeetingRequestManager : AccessTokenRequestManager {
	id <DeclineMeetingRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)declineMeeting:(MeetingDTO *)meeting;

@end