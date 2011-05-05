//
//  StringUtils.m
//  meep
//
//  Created by Alex Jarvis on 28/12/2010.
//  Copyright 2010 Alex Jarvis. All rights reserved.
//

#import "StringUtils.h"

#import "RegexKitLite.h"

@implementation StringUtils

+ (NSString *)stripNonNumericCharsFromString:(NSString *)string {
	return [string stringByReplacingOccurrencesOfRegex:@"[^0-9]+" withString:@""];
}

@end