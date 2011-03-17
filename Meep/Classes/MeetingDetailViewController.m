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
#import "UserDTO.h"
#import "AttendeeDTO.h"
#import "ISO8601DateFormatter.h"
#import "AlertView.h"
#import "MeetingAttendeesViewController.h"
#import "MeepStyleSheet.h"
#import "LocalNotificationManager.h"

@interface MeetingDetailViewController (private)
- (void)updateTableWithMeeting:(MeetingDTO *)newMeeting;
- (void)rollbackSelectedSegment;
- (void)showAlertMeSlider;
- (void)hideAlertMeSlider;
- (void)addDeleteButton;
- (void)deleteMeeting;
- (void)deleteMeetingButtonPressed;
@end

@implementation MeetingDetailViewController

@synthesize thisMeeting;
@synthesize acceptMeetingRequestManager;
@synthesize declineMeetingRequestManager;
@synthesize deleteMeetingRequestManager;
@synthesize updateMinutesBeforeRequestManager;
@synthesize meetingDetailCell;
@synthesize deleteMeetingButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Meeting details";
    
    // Default values
    listenToSegmentChanges = YES;
    showAlertMeSlider = NO;
    
    ConfigManager *configManager = [[MeepAppDelegate sharedAppDelegate] configManager];
    acceptMeetingRequestManager = [[AcceptMeetingRequestManager alloc] initWithAccessToken:configManager.accessToken];
	[acceptMeetingRequestManager setDelegate:self];
    declineMeetingRequestManager = [[DeclineMeetingRequestManager alloc] initWithAccessToken:configManager.accessToken];
	[declineMeetingRequestManager setDelegate:self];
    deleteMeetingRequestManager = [[DeleteMeetingRequestManager alloc] initWithAccessToken:configManager.accessToken];
    [deleteMeetingRequestManager setDelegate:self];
    updateMinutesBeforeRequestManager = [[UpdateMinutesBeforeRequestManager alloc] initWithAccessToken:configManager.accessToken];
    [updateMinutesBeforeRequestManager setDelegate:self];
    
    // Load the cell into memory before the TableViewDelegate cellForRowAtIndex method because we need to set up
    // and calculate its data.
    if (meetingDetailCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeetingDetailCell" owner:self options:nil];
        self.meetingDetailCell = (MeetingDetailCell *)[nib objectAtIndex:0];
        [meetingDetailCell setDelegate:self];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	if (thisMeeting!= nil) {
		[self updateTableWithMeeting:thisMeeting];
        
        // If the current user is the owner of the meeting then add the delete button to the table view footer;
        UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
        if ([currentUser._id isEqualToNumber:thisMeeting.owner._id]) {
            [self addDeleteButton];
        }
	}
}

- (void)updateTableWithMeeting:(MeetingDTO *)newMeeting {
    
    self.thisMeeting = newMeeting;
    
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    
    // Set counters
    awaitingReply = 0;
    attending = 0;
    notAttending = 0;
    for (AttendeeDTO *attendee in thisMeeting.attendees) {
        
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
                showAlertMeSlider = YES;
            }
        } else if ([attendee.rsvp isEqualToString:kNotAttendingKey]) {
            notAttending++;
            if ([attendee._id isEqualToNumber:currentUser._id]) {
                listenToSegmentChanges = NO;
                meetingDetailCell.attendingControl.selectedSegmentIndex = 1;
                oldSegmentValue = 1;
                listenToSegmentChanges = YES;
                showAlertMeSlider = NO;
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

- (void)addDeleteButton {
    // Create meeting button
	[TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	TTButton *button = [TTButton buttonWithStyle:@"redButton:" title:@"Delete Meeting"];
	button.font = [UIFont boldSystemFontOfSize:14];
	[button sizeToFit];
	[button addTarget:self action:@selector(deleteMeetingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[deleteMeetingButton addSubview:button];
}

- (void)deleteMeetingButtonPressed {
    deleteMeetingAlertView = [[UIAlertView alloc]
						  initWithTitle:@"Delete Meeting" 
						  message:@"Are you sure?"
						  delegate:self 
						  cancelButtonTitle:@"No" 
						  otherButtonTitles:@"Yes", nil];
	[deleteMeetingAlertView show];
	[deleteMeetingAlertView release];
}

- (void)deleteMeeting {
    [deleteMeetingRequestManager deleteMeeting:thisMeeting];
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
    [deleteMeetingRequestManager release];
    [updateMinutesBeforeRequestManager release];
    [deleteMeetingButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Private

- (void)showAlertMeSlider {
    [meetingDetailCell hideAlertMeSlider];
    showAlertMeSlider = YES;
    [[super tableView] reloadData];
}

- (void)hideAlertMeSlider {
    [meetingDetailCell hideAlertMeSlider];
    showAlertMeSlider = NO;
    [[super tableView] reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (thisMeeting.description) {
        return 3;
    }
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Meeting details";
    } else if (section == 1) {
        return @"Actions";
    } else if (section == 2) {
        return @"Description";
    }
	return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (thisMeeting != nil) {
        
        NSUInteger section = [indexPath section];
        NSUInteger row = [indexPath row];
        
        if (section == 0 && row == 0) {
            
            // MeetingDetailCell
            
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
            
            if (showAlertMeSlider) {
                [meetingDetailCell showAlertMeSlider];
            } else {
                [meetingDetailCell hideAlertMeSlider];
            }
            
            return meetingDetailCell;
        
        } else if (section == 1) {
            
            static NSString *CellIdentifier = @"AttendeeCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (row == 0) {
                cell.textLabel.text = @"View live meeting map";
            } else if (row == 1) {                
                cell.textLabel.text = [NSString stringWithFormat:@"View attendees (%u)", [thisMeeting.attendees count]];
            }
            return cell;
            
        } else if (thisMeeting.description != nil && section == 2 && row == 0) {
                
            // Meeting Description   
            static NSString *CellIdentifier = @"DescriptionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            UILabel *label = nil;
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                label = [[UILabel alloc] initWithFrame:CGRectZero];
                [label setLineBreakMode:UILineBreakModeWordWrap];
                [label setMinimumFontSize:DESC_CELL_FONT_SIZE];
                [label setNumberOfLines:0];
                [label setFont:[UIFont systemFontOfSize:DESC_CELL_FONT_SIZE]];
                [label setTag:1];
                
                [[cell contentView] addSubview:label];
            }
            
            // Dynamic height based on description text size
            NSString *text = thisMeeting.description;
            CGSize constraint = CGSizeMake(DESC_CELL_WIDTH - (DESC_CELL_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:DESC_CELL_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            if (label != nil) {
                label = (UILabel*)[cell viewWithTag:1];
                [label setText:text];
                [label setFrame:CGRectMake(DESC_CELL_MARGIN, DESC_CELL_MARGIN, DESC_CELL_WIDTH - (DESC_CELL_MARGIN * 2), MAX(size.height, 44.0f))];
            }
            
            return cell;
        }
        
        
    }
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0 && row == 0) {
        // Value of height from MeetingDetailCell.xib
        if (showAlertMeSlider) {
            return MeetingDetailCellHeightExpanded;
        } else {
            return MeetingDetailCellHeightNormal;
        }
    
    } else if (section == 2 && row == 0 && thisMeeting.description != nil) {
        // Dynamic height based on description text size
        CGSize constraint = CGSizeMake(DESC_CELL_WIDTH - (DESC_CELL_MARGIN * 2), 20000.0f);
        CGSize size = [thisMeeting.description sizeWithFont:[UIFont systemFontOfSize:DESC_CELL_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = MAX(size.height, 44.0f);
        return height + (DESC_CELL_MARGIN * 2);
    }
    
    // default value
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if (section == 1) {
        if (row == 0) {
            // View live meeting map
        } else if (row == 1) {
            // View attendees
            MeetingAttendeesViewController *meetingAttendeesViewController = [[MeetingAttendeesViewController alloc] initWithNibName:@"MeetingAttendeesViewController" bundle:nil];
            [meetingAttendeesViewController setMeeting:thisMeeting];
            [self.navigationController pushViewController:meetingAttendeesViewController animated:YES];
            [meetingAttendeesViewController release];
        }
    }
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

- (void)alertMeSliderDidEndEditing:(NSNumber *)minutes {
    //
    minutesBefore = [minutes retain];
    [updateMinutesBeforeRequestManager updateMinutesBefore:minutes forMeeting:thisMeeting];
}

#pragma mark -
#pragma mark AcceptMeetingRequestManagerDelegate

- (void)acceptMeetingSuccessful {
    listenToSegmentChanges = YES;
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    for (AttendeeDTO *attendee in thisMeeting.attendees) {
        if ([attendee._id isEqualToNumber:currentUser._id]) {
            attendee.rsvp = kAttendingKey;
            [self updateTableWithMeeting:thisMeeting];
            break;
        }
    }
    [LocalNotificationManager updateLocalNotificationForMeeting:thisMeeting andUser:currentUser];
}

- (void)acceptMeetingFailedWithError:(NSError *)error {
    [self rollbackSelectedSegment];
    [self showAlertMeSlider];
}

- (void)acceptMeetingFailedWithNetworkError:(NSError *)error {
    [self rollbackSelectedSegment];
    [self showAlertMeSlider];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark DeclineMeetingRequestManagerDelegate

- (void)declineMeetingSuccessful {
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    for (AttendeeDTO *attendee in thisMeeting.attendees) {
        if ([attendee._id isEqualToNumber:currentUser._id]) {
            attendee.rsvp = kNotAttendingKey;
            [self updateTableWithMeeting:thisMeeting];
            break;
        }
    }
    [LocalNotificationManager cancelLocalNotificationForMeeting:thisMeeting];
}

- (void)declineMeetingFailedWithError:(NSError *)error {
    [self rollbackSelectedSegment];
    [self hideAlertMeSlider];
}

- (void)declineMeetingFailedWithNetworkError:(NSError *)error {
    [self rollbackSelectedSegment];
    [self hideAlertMeSlider];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark DeleteMeetingRequestManagerDelegate

- (void)deleteMeetingSuccessful {
    NSLog(@"delete meeting successful");
    [LocalNotificationManager cancelLocalNotificationForMeeting:thisMeeting];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteMeetingFailedWithError:(NSError *)error {
    //
}

- (void)deleteMeetingFailedWithNetworkError:(NSError *)error {
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark UpdateMinutesBeforeRequestManagerDelegate

- (void)updateMinutesBeforeSuccessful {
    // Update Model
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    for (AttendeeDTO *attendee in thisMeeting.attendees) {
        if ([attendee._id isEqualToNumber:currentUser._id]) {
            attendee.minutesBefore = minutesBefore;
            break;
        }
    }
    // Update Local Notifications
    [LocalNotificationManager updateLocalNotificationForMeeting:thisMeeting andUser:currentUser];
}

- (void)updateMinutesBeforeFailedWithError:(NSError *)error {
    [meetingDetailCell rollbackAlertMeSlider];
}

- (void)updateMinutesBeforeFailedWithNetworkError:(NSError *)error {
    [meetingDetailCell rollbackAlertMeSlider];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:deleteMeetingAlertView]) {
		switch (buttonIndex) {
			case 0:
				// Cancel
				break;
			case 1:
				// Logout
				[self deleteMeeting];
				break;
			default:
				break;
		}
	}
}

@end

