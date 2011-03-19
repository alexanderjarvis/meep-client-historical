//
//  RelativeDate.m
//  Meep
//
//  Created by Alex Jarvis on 19/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RelativeDate.h"

#define minute 60
#define hour (minute * 60)
#define day (hour * 24)
#define week (day * 7)
#define month (day * 31)
#define year (day * 365)

@implementation RelativeDate

/*
 * Returns a nice relative time string with whatever NSDate you give it.
 *
 * Works for dates in the future and in the past.
 *
 * Past example - 2 minutes ago, 1 hour ago, yesterday, 2 days ago, a week ago, 2 weeks ago
 *
 * Future example - in 1 hour, in 5 minutes, in 3 days, in 1 week, tomorrow
 */
+ (NSString *)stringWithDate:(NSDate *)date {
    
    // (interval is in seconds)
    NSTimeInterval interval = [date timeIntervalSinceNow];
    
    // Need a positive time interval for working out the unit of time.
    NSInteger positiveSeconds = (int)interval;
    if (interval < 0) {
        positiveSeconds = (int)-interval;
    }
    
    // Work out unit of time to display e.g. second, minute, hour, day, week, month, year
    NSString *unitOfTime = nil;
    
    if (positiveSeconds < minute) {
        // second(s)
        if (positiveSeconds == 1) {
            unitOfTime = @"1 second";
        } else {
            unitOfTime = [NSString stringWithFormat:@"%i seconds", positiveSeconds];
        }
        
    } else if (positiveSeconds >= minute && positiveSeconds < hour) {
        // minute(s)
        if (positiveSeconds < (minute * 2)) {
            unitOfTime = @"1 minute";
        } else {
            unitOfTime = [NSString stringWithFormat:@"%i minutes", (int)round(positiveSeconds / minute)];
        }
            
    } else if (positiveSeconds >= hour && positiveSeconds < day) {
        // hour(s)
        if (positiveSeconds < (hour * 2)) {
            unitOfTime = @"1 hour";
        } else {
            unitOfTime = [NSString stringWithFormat:@"%i hours", (int)round(positiveSeconds / hour)];
        }
        
    } else if (positiveSeconds >= day && positiveSeconds < week) {
        // day(s) - //TODO: possibly tomorrow / yesterday
        if (positiveSeconds < (day * 2)) {
            unitOfTime = @"1 day";
        } else {
            unitOfTime = [NSString stringWithFormat:@"%i days", (int)round(positiveSeconds / day)];
        }
        
    } else if (positiveSeconds >= week && positiveSeconds < month) {
        // week(s)
        if (positiveSeconds < (week * 2)) {
            unitOfTime = @"1 week";
        } else {
            unitOfTime = [NSString stringWithFormat:@"%i weeks", (int)round(positiveSeconds / week)];
        }
        
    } else if (positiveSeconds >= month && positiveSeconds < year) {
        // month(s)
        if (positiveSeconds < (month * 2)) {
            unitOfTime = @"1 month";
        } else {
            unitOfTime = [NSString stringWithFormat:@"%i months", (int)round(positiveSeconds / month)];
        }
        
    } else if (positiveSeconds >= year) {
        // year(s)
        if (positiveSeconds < (year * 2)) {
            unitOfTime = @"1 year";
        } else {
            unitOfTime = [NSString stringWithFormat:@"%i years", (int)round(positiveSeconds / year)];
        }
    }
    
    
    NSString *resultString = nil;
    
    // If negative value, then date is in the past
    if (interval < 0) {
    
        resultString = [NSString stringWithFormat:@"%@ ago", unitOfTime];
        
    // In the Future
    } else {
        
        resultString = [NSString stringWithFormat:@"in %@", unitOfTime];
        
    }
    
    return resultString;
}

@end
