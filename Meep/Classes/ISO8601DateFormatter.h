//
//  ISO8601DateFormatter.h
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISO8601DateFormat @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

@interface ISO8601DateFormatter : NSObject {

}

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
