//
//  LocalNotificationManager.h
//  Meep
//
//  Created by Alex Jarvis on 16/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserDTO.h"

#define kMeetingIdKey @"meeting_id"

@interface LocalNotificationManager : NSObject {
    
}

+ (void)checkAndUpdateLocalNotificationsForUser:(UserDTO *)user;
+ (void)updateLocalNotificationForMeeting:(MeetingDTO *)meeting andUser:(UserDTO *)user;
+ (void)cancelLocalNotificationForMeeting:(MeetingDTO *)meeting;
+ (void)cancelAllLocalNotifications;

@end
