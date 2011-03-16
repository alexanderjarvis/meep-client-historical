//
//  AttendeeDTO.h
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AttendeeDTO : NSObject {
    
	NSNumber *_id;
	NSString *firstName;
	NSString *lastName;
	NSString *rsvp;
    NSNumber *minutesBefore;
    
}

@property (nonatomic, copy) NSNumber *_id;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *rsvp;
@property (nonatomic, copy) NSNumber *minutesBefore;

@end
