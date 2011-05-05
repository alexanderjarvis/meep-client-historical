//
//  DateFormatter.m
//  Meep
//
//  Created by Alex Jarvis on 18/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "DateFormatter.h"

#import "ISO8601DateFormatter.h"

@implementation DateFormatter

+ (NSDate *)dateFromString:(NSString *)string {
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    [dateFormatter setIncludeTime:YES];
    NSDate *date = [dateFormatter dateFromString:string];
    [dateFormatter release];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    [dateFormatter setIncludeTime:YES];
    NSString *string = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return string;
}

@end
