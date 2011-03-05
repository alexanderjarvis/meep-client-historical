//
//  MeetingDetailViewController.m
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingDetailViewController.h"

#import "MeepAppDelegate.h"
#import "MeetingDetailCell.h"
#import "User.h"
#import "AttendeeDTO.h"
#import "ISO8601DateFormatter.h"
#import "AlertView.h"

@implementation MeetingDetailViewController

@synthesize thisMeeting;
@synthesize acceptMeetingRequestManager;
@synthesize declineMeetingRequestManager;
@synthesize meetingDetailCell;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Meeting details";
    
    // Default value;
    listenToSegmentChanges = YES;
    
    MeepAppDelegate *meepAppDelegate = [MeepAppDelegate sharedAppDelegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
    acceptMeetingRequestManager = [[AcceptMeetingRequestManager alloc] initWithAccessToken:configManager.access_token];
	[acceptMeetingRequestManager setDelegate:self];
    declineMeetingRequestManager = [[DeclineMeetingRequestManager alloc] initWithAccessToken:configManager.access_token];
	[declineMeetingRequestManager setDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Load the cell into memory before the TableViewDelegate cellForRowAtIndex method because we need to set up
    // and calculate its data.
    if (meetingDetailCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeetingDetailCell" owner:self options:nil];
        self.meetingDetailCell = (MeetingDetailCell *)[nib objectAtIndex:0];
        [meetingDetailCell setDelegate:self];
    }
	
	if (thisMeeting != nil) {
		[self updateTableWithMeeting:thisMeeting];
	}
}

- (void)updateTableWithMeeting:(MeetingDTO *)meeting {
    
    self.thisMeeting = meeting;
    
    User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    
    // Set counters
    awaitingReply = 0;
    attending = 0;
    notAttending = 0;
    for (AttendeeDTO *attendee in meeting.attendees) {
        
        if (attendee.rsvp == nil) {
            awaitingReply++;
            oldSegmentValue = -1;
        } else if ([attendee.rsvp isEqualToString:kAttendingKey]) {
            attending++;
            if ([attendee._id isEqualToNumber:currentUser._id]) {
                listenToSegmentChanges = NO;
                meetingDetailCell.attendingControl.selectedSegmentIndex = 0;
                oldSegmentValue = 0;
                listenToSegmentChanges = YES;
            }
        } else if ([attendee.rsvp isEqualToString:kNotAttendingKey]) {
            notAttending++;
            if ([attendee._id isEqualToNumber:currentUser._id]) {
                listenToSegmentChanges = NO;
                meetingDetailCell.attendingControl.selectedSegmentIndex = 1;
                oldSegmentValue = 1;
                listenToSegmentChanges = YES;
            }
        }
    }
    
    [[super tableView] reloadData];
}

- (void)rollbackSelectedSegment {
    // Reset segment value, but without the another request being triggered.
    listenToSegmentChanges = NO;
    meetingDetailCell.attendingControl.selectedSegmentIndex = oldSegmentValue;
    listenToSegmentChanges = YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[thisMeeting release];
    [acceptMeetingRequestManager release];
    [declineMeetingRequestManager release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Meeting details";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (thisMeeting != nil && [indexPath row] == 0) {
        
        // Configure the cell...
        // Title
        meetingDetailCell.titleLabel.text = thisMeeting.title;
        // Date and time
        NSDate *date = [ISO8601DateFormatter dateFromString:thisMeeting.time];
        meetingDetailCell.dateLabel.text = [NSDateFormatter localizedStringFromDate:date 
                                                             dateStyle:kCFDateFormatterLongStyle 
                                                             timeStyle:kCFDateFormatterNoStyle];
        NSString *time = [NSDateFormatter localizedStringFromDate:date 
                                                        dateStyle:kCFDateFormatterNoStyle
                                                        timeStyle:kCFDateFormatterShortStyle];
        meetingDetailCell.timeLabel.text = [NSString stringWithFormat:@"at %@", time];
        // Accepted and declined counters
        meetingDetailCell.acceptedAmountLabel.text = [NSString stringWithFormat:@"%u", attending];
        meetingDetailCell.declinedAmountLabel.text = [NSString stringWithFormat:@"%u", notAttending];
        meetingDetailCell.awaitingReplyAmountLabel.text = [NSString stringWithFormat:@"%u", awaitingReply];
        return meetingDetailCell;
    }
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Value of height from MeetingDetailCell.xib
    if ([indexPath row] == 0) {
        return 144;
    }
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark -
#pragma mark MeetingDetailCellDelegate

- (void)attendingButtonPressed {
    if (listenToSegmentChanges) {
        [acceptMeetingRequestManager acceptMeeting:thisMeeting];
    }
}

- (void)notAttendingButtonPressed {
    if (listenToSegmentChanges) {
        [declineMeetingRequestManager declineMeeting:thisMeeting];
    }
}

#pragma mark -
#pragma mark AcceptMeetingRequestManagerDelegate

- (void)acceptMeetingSuccessful:(MeetingDTO *)meeting {
    User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    for (AttendeeDTO *attendee in meeting.attendees) {
        if ([attendee._id isEqualToNumber:currentUser._id]) {
            attendee.rsvp = kAttendingKey;
            [self updateTableWithMeeting:meeting];
        }
    }
}

- (void)acceptMeetingFailedWithError:(NSError *)error {
    [self rollbackSelectedSegment];
}

- (void)acceptMeetingFailedWithNetworkError:(NSError *)error {
    [self rollbackSelectedSegment];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark DeclineMeetingRequestManagerDelegate

- (void)declineMeetingSuccessful:(MeetingDTO *)meeting {
    User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    for (AttendeeDTO *attendee in meeting.attendees) {
        if ([attendee._id isEqualToNumber:currentUser._id]) {
            attendee.rsvp = kNotAttendingKey;
            [self updateTableWithMeeting:meeting];
        }
    }
}

- (void)declineMeetingFailedWithError:(NSError *)error {
    [self rollbackSelectedSegment];
}

- (void)declineMeetingFailedWithNetworkError:(NSError *)error {
    [self rollbackSelectedSegment];
    [AlertView showNetworkAlert:error];
}


@end

