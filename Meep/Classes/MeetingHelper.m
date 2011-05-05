//
//  MeetingHelper.m
//  Meep
//
//  Created by Alex Jarvis on 23/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "MeetingHelper.h"

#import "DateFormatter.h"

@implementation MeetingHelper

+ (BOOL)isMeetingOld:(MeetingDTO *)meeting {
    NSDate *meetingDate = [DateFormatter dateFromString:meeting.time];
    if ([meetingDate timeIntervalSinceNow] < -TwentyFourHoursInSeconds) {
        return YES;
    }
    return NO;
}

@end
