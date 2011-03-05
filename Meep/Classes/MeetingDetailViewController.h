//
//  MeetingDetailViewController.h
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeetingDetailCellDelegate.h"
#import "AcceptMeetingRequestManagerDelegate.h"
#import "DeclineMeetingRequestManagerDelegate.h"
#import "MeetingDTO.h"
#import "MeetingDetailCell.h"

#define kAttendingKey @"YES"
#define kNotAttendingKey @"NO"

@interface MeetingDetailViewController : UITableViewController <MeetingDetailCellDelegate, 
                                                                AcceptMeetingRequestManagerDelegate, 
                                                                DeclineMeetingRequestManagerDelegate> {
    NSUInteger awaitingReply;
    NSUInteger attending;
    NSUInteger notAttending;
	MeetingDTO *thisMeeting;                                                                   
    AcceptMeetingRequestManager *acceptMeetingRequestManager;
    DeclineMeetingRequestManager *declineMeetingRequestManager;
    MeetingDetailCell *meetingDetailCell;
    BOOL listenToSegmentChanges;
    NSInteger oldSegmentValue;
}

@property (nonatomic, retain) MeetingDTO *thisMeeting;
@property (nonatomic, retain) AcceptMeetingRequestManager *acceptMeetingRequestManager;
@property (nonatomic, retain) DeclineMeetingRequestManager *declineMeetingRequestManager;
@property (nonatomic, retain) MeetingDetailCell *meetingDetailCell;

- (void)updateTableWithMeeting:(MeetingDTO *)meeting;
- (void)rollbackSelectedSegment;

@end
