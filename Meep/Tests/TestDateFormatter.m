//
//  TestDateFormatter.m
//  Meep
//
//  Created by Alex Jarvis on 29/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "TestDateFormatter.h"

#import "DateFormatter.h"

@implementation TestDateFormatter

- (void)testStringFromDateWithTimeZone {
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"BST"]];
    [NSTimeZone resetSystemTimeZone];
    NSDate *dateNow = [NSDate date];
    
    NSLog(@"date now: %@", dateNow);
    NSString *dateNowString = [DateFormatter stringFromDate:dateNow];
    NSLog(@"date now ISO string: %@", dateNowString);
    
    NSDate *dateFromString = [DateFormatter dateFromString:dateNowString];
    NSLog(@"date now back from ISO string: %@", dateFromString);
    
    STAssertTrue([[dateNow description] isEqualToString:[dateFromString description]], @"Dates do not equal");
}

- (void)testDateFromStringWithTimeZone {
    
    NSDate *dateFromString = [DateFormatter dateFromString:@"2011-03-29T13:27:17+0100"];
    NSString *expectedDateFromString = @"2011-03-29 12:27:17 +0000";
    
    STAssertEqualObjects([dateFromString description], expectedDateFromString, @"Dates do not equal");
}

@end
