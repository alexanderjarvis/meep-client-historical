//
//  MeetingsRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "MeetingsRequestManagerDelegate.h"

@interface MeetingsRequestManager : AccessTokenRequestManager {
	id <MeetingsRequestManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)getMeetings;

@end
