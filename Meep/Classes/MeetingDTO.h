//
//  MeetingDTO.h
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoordinateDTO.h"
#import "AttendeeDTO.h"
#import "UserSummaryDTO.h"

#define kAttendingKey @"YES"
#define kNotAttendingKey @"NO"

@interface MeetingDTO : NSObject {
    
	NSNumber *_id;
	NSString *time;
	CoordinateDTO *place;
	NSArray *attendees;
	AttendeeDTO *_type_attendees;
	UserSummaryDTO *owner;
	NSString *title;
	NSString *description;
    
}

@property (nonatomic, copy) NSNumber *_id;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, retain) CoordinateDTO *place;
@property (nonatomic, retain) NSArray *attendees;
@property (nonatomic, retain) AttendeeDTO *_type_attendees;
@property (nonatomic, retain) UserSummaryDTO *owner;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;

- (id)init;

@end
