//
//  MeetingHelper.h
//  Meep
//
//  Created by Alex Jarvis on 23/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MeetingDTO.h"

#define TwentyFourHoursInSeconds (24 * 60 * 60)

@interface MeetingHelper : NSObject {
    
}

+ (BOOL)isMeetingOld:(MeetingDTO *)meeting;

@end
