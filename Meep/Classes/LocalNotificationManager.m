//
//  LocalNotificationManager.m
//  Meep
//
//  Created by Alex Jarvis on 16/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocalNotificationManager.h"

#import "ISO8601DateFormatter.h"

@interface LocalNotificationManager (private)

+ (UILocalNotification *)localNotificationForMeetingWithId:(NSNumber *)_id;

@end

@implementation LocalNotificationManager

+ (void)checkAndUpdateLocalNotificationsForUser:(UserDTO *)user {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // Remove any local notification that were previously created but no longer exist as meetings for this user.
    for (UILocalNotification *notification in localNotifications) {
        UILocalNotification *meetingNotification = nil;
        for (MeetingDTO *meeting in user.meetingsRelated) {
            if ([[notification.userInfo valueForKey:kMeetingIdKey] isEqualToNumber:meeting._id]) {
                meetingNotification = notification;
                break;
            }
        }
        // If the meeting could not be found, then cancel the notification for it.
        if (meetingNotification == nil) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    // Update and create local notifications from the meetings this user is related to.
    for (MeetingDTO *meeting in user.meetingsRelated) {
        [self updateLocalNotificationForMeeting:meeting andUser:user];
    }
}

+ (void)updateLocalNotificationForMeeting:(MeetingDTO *)meeting andUser:(UserDTO *)user {
    for (AttendeeDTO *attendee in meeting.attendees) {
        if ([attendee._id isEqualToNumber:user._id]) {
            
            UILocalNotification *meetingNotification = [self localNotificationForMeetingWithId:meeting._id];
            
            BOOL scheduleNotification = NO;
            
            // If a notification does not exist for this meeting, then create one.
            if (meetingNotification == nil && [attendee.rsvp isEqualToString:kAttendingKey] && attendee.minutesBefore != nil) {
                meetingNotification = [[UILocalNotification alloc] init];
                meetingNotification.alertAction = @"Live Map!";
                meetingNotification.hasAction = YES;
                meetingNotification.userInfo = [NSDictionary dictionaryWithObject:meeting._id forKey:kMeetingIdKey];
                scheduleNotification = YES;
            }
            
            if (meetingNotification != nil) {
                
                // Cancel the notification if the RSVP has changed to NO
                if ([attendee.rsvp isEqualToString:kNotAttendingKey]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:meetingNotification];
                    
                // Update / Set the local notifications properties.
                } else {
                    NSDate *meetingDate = [ISO8601DateFormatter dateFromString:meeting.time];
                    NSDate *fireDate = [NSDate dateWithTimeInterval:-([attendee.minutesBefore doubleValue] * 60) 
                                                          sinceDate:meetingDate];
                    meetingNotification.fireDate = fireDate;
                    meetingNotification.alertBody = [NSString stringWithFormat:@"%@ minute(s) until:\n %@\n\nView the Live Map now!",
                                                     attendee.minutesBefore, 
                                                     meeting.title];
                    if (scheduleNotification) {
                        // Only schedule the notification if the fire date is in the future.
                        if (fireDate == [fireDate laterDate:[NSDate date]]) {
                            [[UIApplication sharedApplication] scheduleLocalNotification:meetingNotification];
                        }
                        [meetingNotification release];
                    }
                }
            }
            
            break;
        }
    }
}

+ (void)cancelLocalNotificationForMeeting:(MeetingDTO *)meeting {
    UILocalNotification *notification = [self localNotificationForMeetingWithId:meeting._id];
    if (notification != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

+ (void)cancelAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark -
#pragma mark private

+ (UILocalNotification *)localNotificationForMeetingWithId:(NSNumber *)_id {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *meetingNotification = nil;
    for (UILocalNotification *localNotification in localNotifications) {
        if ([[localNotification.userInfo valueForKey:kMeetingIdKey] isEqualToNumber:_id]) {
            meetingNotification = localNotification;
            break;
        }
    }
    return meetingNotification;
}

@end
