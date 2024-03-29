//
//  MeetingsViewController.h
//  Meep
//
//  Created by Alex Jarvis on 02/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeetingsRequestManager.h"
#import "AcceptMeetingRequestManager.h"
#import "DeclineMeetingRequestManager.h"

@interface MeetingsViewController : UITableViewController {
    
	MeetingsRequestManager *meetingsRequestManager;
	AcceptMeetingRequestManager *acceptMeetingRequestManager;
    DeclineMeetingRequestManager *declineMeetingRequestManager;
	NSArray *tableKeys;
	NSDictionary *tableDictionary;
}

@property (nonatomic, retain) NSArray *tableKeys;
@property (nonatomic, retain) NSDictionary *tableDictionary;

- (void)updateTableWithMeetings:(NSArray *)meetings;

@end
