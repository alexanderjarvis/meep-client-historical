//
//  Math.m
//  Meep
//
//  Created by Alex Jarvis on 15/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Math.h"


@implementation Math

+ (double)roundToTwoDecimalPlaces:(double)number {
    return round(number * 100) / 100;
}

@end
