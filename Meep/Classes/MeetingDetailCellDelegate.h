//
//  MeetingDetailCellDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 05/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetingDetailCellDelegate <NSObject>

@required

- (void)attendingButtonPressed;

- (void)notAttendingButtonPressed;

- (void)alertMeSliderDidEndEditing:(NSNumber *)minutes;

@end