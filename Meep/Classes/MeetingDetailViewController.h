//
//  MeetingDetailViewController.h
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

#import "MeetingDetailCell.h"
#import "AcceptMeetingRequestManager.h"
#import "DeclineMeetingRequestManager.h"
#import "DeleteMeetingRequestManager.h"
#import "UpdateMinutesBeforeRequestManager.h"
#import "MeetingDTO.h"
#import "MeetingDetailCell.h"
#import "MBProgressHUD.h"

#define DESC_CELL_FONT_SIZE 13.0f
#define DESC_CELL_WIDTH 300.0f
#define DESC_CELL_MARGIN 10.0f

@interface MeetingDetailViewController : UITableViewController <MeetingDetailCellDelegate, 
                                                                AcceptMeetingRequestManagerDelegate, 
                                                                DeclineMeetingRequestManagerDelegate,
                                                                DeleteMeetingRequestManagerDelegate,
                                                                UpdateMinutesBeforeRequestManagerDelegate,
                                                                UIAlertViewDelegate> {
    NSUInteger awaitingReply;
    NSUInteger attending;
    NSUInteger notAttending;
                                                                    
    MeetingDTO *previousMeeting;
	MeetingDTO *thisMeeting;                                                                   
    AcceptMeetingRequestManager *acceptMeetingRequestManager;
    DeclineMeetingRequestManager *declineMeetingRequestManager;
    DeleteMeetingRequestManager *deleteMeetingRequestManager;
    UpdateMinutesBeforeRequestManager *updateMinutesBeforeRequestManager;
    MeetingDetailCell *meetingDetailCell;
    BOOL listenToSegmentChanges;
    BOOL showAlertMeSlider;
    NSInteger oldSegmentValue;
                                                                    
    IBOutlet UIButton *deleteMeetingButton;
    UIAlertView *deleteMeetingAlertView;
    NSNumber *minutesBefore;
                                                                    
    MBProgressHUD *hud;
}

@property (nonatomic, retain) MeetingDTO *previousMeeting;
@property (nonatomic, retain) MeetingDTO *thisMeeting;
@property (nonatomic, retain) AcceptMeetingRequestManager *acceptMeetingRequestManager;
@property (nonatomic, retain) DeclineMeetingRequestManager *declineMeetingRequestManager;
@property (nonatomic, retain) DeleteMeetingRequestManager *deleteMeetingRequestManager;
@property (nonatomic, retain) UpdateMinutesBeforeRequestManager *updateMinutesBeforeRequestManager;
@property (nonatomic, retain) MeetingDetailCell *meetingDetailCell;
@property (nonatomic, retain) UIButton *deleteMeetingButton;

@end
