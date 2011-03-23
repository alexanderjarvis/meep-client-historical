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
#import "DateFormatter.h"
#import "AlertView.h"
#import "MeetingAttendeesViewController.h"
#import "MeepStyleSheet.h"
#import "LocalNotificationManager.h"
#import "MeetingHelper.h"

@interface MeetingDetailViewController (private)

- (void)updateTableWithMeeting:(MeetingDTO *)newMeeting;
- (void)rollbackSelectedSegment;
- (void)showAlertMeSlider;
- (void)hideAlertMeSlider;
- (void)addDeleteButton;
- (void)removeDeleteButton;
- (void)deleteMeeting;
- (void)deleteMeetingButtonPressed;

@end

@implementation MeetingDetailViewController

@synthesize previousMeeting;
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
    
    // HUD
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Detect if the view actually needs updating
    if (thisMeeting != nil && thisMeeting != previousMeeting) {
        
        previousMeeting = thisMeeting;
        listenToSegmentChanges = YES;
        showAlertMeSlider = NO;
        [self removeDeleteButton];         
        
        [self updateTableWithMeeting:thisMeeting];
        [[super tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
                                 atScrollPosition:UITableViewScrollPositionTop animated:NO];
        

        // If the current user is the owner of the meeting then add the delete button to the table view footer;
        UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
        if ([currentUser._id isEqualToNumber:thisMeeting.owner._id]) {
            [self addDeleteButton];
        }
    }
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
    [hud release];
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
#pragma mark MeetingDetailViewController

- (void)updateTableWithMeeting:(MeetingDTO *)newMeeting {
    
    self.thisMeeting = newMeeting;
    
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    
    // Set counters
    awaitingReply = 0;
    attending = 0;
    notAttending = 0;
    
    listenToSegmentChanges = NO;
    for (AttendeeDTO *attendee in thisMeeting.attendees) {
        
        if (attendee.rsvp == nil) {
            awaitingReply++;
            if ([attendee._id isEqualToNumber:currentUser._id]) {
                meetingDetailCell.attendingControl.selectedSegmentIndex = -1;
                oldSegmentValue = -1;
            }
        } else if ([attendee.rsvp isEqualToString:kAttendingKey]) {
            attending++;
            if ([attendee._id isEqualToNumber:currentUser._id]) {
                meetingDetailCell.attendingControl.selectedSegmentIndex = 0;
                oldSegmentValue = 0;
                showAlertMeSlider = YES;
            }
        } else if ([attendee.rsvp isEqualToString:kNotAttendingKey]) {
            notAttending++;
            if ([attendee._id isEqualToNumber:currentUser._id]) {
                meetingDetailCell.attendingControl.selectedSegmentIndex = 1;
                oldSegmentValue = 1;
                showAlertMeSlider = NO;
                
            }
        }
        if ([attendee._id isEqualToNumber:currentUser._id]) {
            // default value
            minutesBefore = [NSNumber numberWithUnsignedInt:15];
            if (attendee.minutesBefore) {
                minutesBefore = attendee.minutesBefore;
            }
            [meetingDetailCell setAlertMeSliderValueWithMinutes:[minutesBefore unsignedIntegerValue]];
        }
    }
    listenToSegmentChanges = YES;
    
    [[super tableView] reloadData];
}

- (void)rollbackSelectedSegment {
    // Reset segment value, but without the another request being triggered.
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

- (void)removeDeleteButton {
    for (UIView *subView in [deleteMeetingButton subviews]) {
        [subView removeFromSuperview];
    }
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
    hud.labelText = @"Deleting...";
    [hud show:YES];
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
            NSDate *date = [DateFormatter dateFromString:thisMeeting.time];
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
            
            static NSString *CellIdentifier = @"ActionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (row == 0) {
                cell.textLabel.text = @"Live Map";
                if ([MeetingHelper isMeetingOld:thisMeeting]) {
                    cell.textLabel.textColor = [UIColor grayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            } else if (row == 1) {                
                cell.textLabel.text = [NSString stringWithFormat:@"Attendees (%u)", [thisMeeting.attendees count]];
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
                
                label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
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
                label = (UILabel *)[cell viewWithTag:1];
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
            if (![MeetingHelper isMeetingOld:thisMeeting]) {
                [[[MeepAppDelegate sharedAppDelegate] menuNavigationController] showLiveMapViewWith:thisMeeting animated:YES];
            }
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
        listenToSegmentChanges = NO;
        [acceptMeetingRequestManager acceptMeeting:thisMeeting];
        hud.labelText = @"Updating...";
        [hud show:YES];
    }
}

- (void)notAttendingButtonPressed {
    if (listenToSegmentChanges) {
        listenToSegmentChanges = NO;
        [declineMeetingRequestManager declineMeeting:thisMeeting];
        hud.labelText = @"Updating...";
        [hud show:YES];
    }
}

- (void)alertMeSliderDidEndEditing:(NSNumber *)minutes {
    //
    minutesBefore = [minutes retain];
    [updateMinutesBeforeRequestManager updateMinutesBefore:minutes forMeeting:thisMeeting];
    hud.labelText = @"Updating...";
    [hud show:YES];
}

#pragma mark -
#pragma mark AcceptMeetingRequestManagerDelegate

- (void)acceptMeetingSuccessful {
    [self showAlertMeSlider];
    [hud hide:NO];
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
    [hud hide:YES];
    [self rollbackSelectedSegment];
    [self showAlertMeSlider];
}

- (void)acceptMeetingFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
    [self rollbackSelectedSegment];
    [self showAlertMeSlider];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark DeclineMeetingRequestManagerDelegate

- (void)declineMeetingSuccessful {
    [self hideAlertMeSlider];
    [hud hide:NO];
    listenToSegmentChanges = YES;
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
    [hud hide:YES];
    [self rollbackSelectedSegment];
    [self hideAlertMeSlider];
}

- (void)declineMeetingFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
    [self rollbackSelectedSegment];
    [self hideAlertMeSlider];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark DeleteMeetingRequestManagerDelegate

- (void)deleteMeetingSuccessful {
    [hud hide:YES];
    // Delete application specific data for this meeting
    [LocalNotificationManager cancelLocalNotificationForMeeting:thisMeeting];
    UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
    NSMutableArray *mutableMeetings = [currentUser.meetingsRelated mutableCopy];
    [mutableMeetings removeObject:thisMeeting];
    [currentUser setMeetingsRelated:[mutableMeetings copy]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteMeetingFailedWithError:(NSError *)error {
    [hud hide:YES];
    // todo show retry to user?
}

- (void)deleteMeetingFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
    [AlertView showNetworkAlert:error];
}

#pragma mark -
#pragma mark UpdateMinutesBeforeRequestManagerDelegate

- (void)updateMinutesBeforeSuccessful {
    [hud hide:YES];
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
    [hud hide:YES];
    [meetingDetailCell rollbackAlertMeSlider];
}

- (void)updateMinutesBeforeFailedWithNetworkError:(NSError *)error {
    [hud hide:YES];
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

