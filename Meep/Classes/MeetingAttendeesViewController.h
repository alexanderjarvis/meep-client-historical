//
//  MeetingAttendeesViewController.h
//  Meep
//
//  Created by Alex Jarvis on 06/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeetingDTO.h"

@interface MeetingAttendeesViewController : UITableViewController {
    NSArray *tableKeys;
	NSDictionary *tableDictionary;
    MeetingDTO *meeting;
}

@property (nonatomic, retain) NSArray *tableKeys;
@property (nonatomic, retain) NSDictionary *tableDictionary;
@property (nonatomic, retain) MeetingDTO *meeting;

- (void)updateTableWithAttendees:(NSArray *)attendees;

@end
