//
//  DateFormatter.h
//  Meep
//
//  Created by Alex Jarvis on 18/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSObject {
    
}

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
