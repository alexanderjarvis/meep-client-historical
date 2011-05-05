//
//  NewMeetingBuilder.h
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MeetingDTO.h"

@interface NewMeetingBuilder : NSObject {
	
	MeetingDTO *meetingDTO;

}

@property (nonatomic, retain) MeetingDTO *meetingDTO;

+ (NewMeetingBuilder *)sharedNewMeetingBuilder;

@end
