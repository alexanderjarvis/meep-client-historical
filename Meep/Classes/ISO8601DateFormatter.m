//
//  ISO8601DateFormatter.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ISO8601DateFormatter.h"


@implementation ISO8601DateFormatter

+ (NSDate *)dateFromString:(NSString *)string {
	NSDateFormatter* iso8601DateFormatter = [[NSDateFormatter alloc] init];
	[iso8601DateFormatter setTimeStyle:NSDateFormatterFullStyle];
	[iso8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	NSDate *date = [iso8601DateFormatter dateFromString:string];
	[iso8601DateFormatter release];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date {
	NSDateFormatter* iso8601DateFormatter = [[NSDateFormatter alloc] init];
	[iso8601DateFormatter setTimeStyle:NSDateFormatterFullStyle];
	[iso8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	NSString *string = [iso8601DateFormatter stringFromDate:date];
	[iso8601DateFormatter release];
	return string;
}

@end
