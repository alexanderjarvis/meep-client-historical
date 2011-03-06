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
#import "DeleteMeetingRequestManagerDelegate.h"
#import "MeetingDTO.h"
#import "MeetingDetailCell.h"

#define kAttendingKey @"YES"
#define kNotAttendingKey @"NO"
#define DESC_CELL_FONT_SIZE 13.0f
#define DESC_CELL_WIDTH 300.0f
#define DESC_CELL_MARGIN 10.0f

@interface MeetingDetailViewController : UITableViewController <MeetingDetailCellDelegate, 
                                                                AcceptMeetingRequestManagerDelegate, 
                                                                DeclineMeetingRequestManagerDelegate,
                                                                DeleteMeetingRequestManagerDelegate,
                                                                UIAlertViewDelegate> {
    NSUInteger awaitingReply;
    NSUInteger attending;
    NSUInteger notAttending;
	MeetingDTO *meeting;                                                                   
    AcceptMeetingRequestManager *acceptMeetingRequestManager;
    DeclineMeetingRequestManager *declineMeetingRequestManager;
    DeleteMeetingRequestManager *deleteMeetingRequestManager;
    MeetingDetailCell *meetingDetailCell;
    BOOL listenToSegmentChanges;
    NSInteger oldSegmentValue;
                                                                    
    IBOutlet UIButton *deleteMeetingButton;
    UIAlertView *deleteMeetingAlertView;
}

@property (nonatomic, retain) MeetingDTO *meeting;
@property (nonatomic, retain) AcceptMeetingRequestManager *acceptMeetingRequestManager;
@property (nonatomic, retain) DeclineMeetingRequestManager *declineMeetingRequestManager;
@property (nonatomic, retain) DeleteMeetingRequestManager *deleteMeetingRequestManager;
@property (nonatomic, retain) MeetingDetailCell *meetingDetailCell;

@property (nonatomic, retain) UIButton *deleteMeetingButton;
@property (nonatomic, retain) UIAlertView *deleteMeetingAlertView;

- (void)updateTableWithMeeting:(MeetingDTO *)newMeeting;
- (void)rollbackSelectedSegment;
- (void)addDeleteButton;
- (void)deleteMeetingButtonPressed;
- (void)deleteMeeting;

@end
