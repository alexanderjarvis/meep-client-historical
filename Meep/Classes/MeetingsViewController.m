//
//  MeetingsViewController.m
//  Meep
//
//  Created by Alex Jarvis on 02/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingsViewController.h"
#import "MeepAppDelegate.h"
#import "ConfigManager.h"
#import "AlertView.h"
#import "MeetingCell.h"
#import "MeetingDTO.h"
#import "MeetingDetailViewController.h"
#import "DateFormatter.h"

@implementation MeetingsViewController

@synthesize tableKeys;
@synthesize tableDictionary;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Meetings";
	
	MeepAppDelegate *meepAppDelegate = [MeepAppDelegate sharedAppDelegate];
	ConfigManager *configManager = [meepAppDelegate configManager];
    meetingsRequestManager = [[MeetingsRequestManager alloc] initWithAccessToken:configManager.accessToken];
	[meetingsRequestManager setDelegate:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	MeepAppDelegate *meepAppDelegate = [MeepAppDelegate sharedAppDelegate];
	[self updateTableWithMeetings:[[meepAppDelegate currentUser] meetingsRelated]];
	
	// Get the meetings
	[meetingsRequestManager getMeetings];
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
	[meetingsRequestManager release];
	[tableKeys release];
	[tableDictionary release];
    [super dealloc];
}

#pragma mark -
#pragma mark MeetingsViewController

- (void)updateTableWithMeetings:(NSArray *)meetings {
	
	// Build up different sections of table
	NSMutableArray *arrayOfAwaitingReply = [NSMutableArray arrayWithCapacity:1];
	NSMutableArray *arrayOfAttending = [NSMutableArray arrayWithCapacity:1];
	NSMutableArray *arrayOfNotAttending = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *arrayOfOld = [NSMutableArray arrayWithCapacity:1];
	
	UserDTO *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	for (MeetingDTO *meeting in meetings) {
        
        // If the meeting date is older than a day
        NSDate *meetingDate = [DateFormatter dateFromString:meeting.time];
        if ([meetingDate timeIntervalSinceNow] < -TwentyFourHoursInSeconds) {
            [arrayOfOld addObject:meeting];
        } else {
            for (AttendeeDTO *attendee in meeting.attendees) {
                if ([attendee._id isEqualToNumber:currentUser._id]) {
                    if (attendee.rsvp == nil) {
                        [arrayOfAwaitingReply addObject:meeting];
                    } else if ([attendee.rsvp isEqualToString:kAttendingKey]) {
                        [arrayOfAttending addObject:meeting];
                    } else if ([attendee.rsvp isEqualToString:kNotAttendingKey]) {
                        [arrayOfNotAttending addObject:meeting];
                    }
                    // Stop iterating attendees when the current user is reached
                    break;
                }
            }
        }
	}
	
	// Declare SortDescriptor to sort the sections by ascending date
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	// Only add sections if they are not empty.
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:4];
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:4];
	if ([arrayOfAwaitingReply count] > 0) {
		[objects addObject:[arrayOfAwaitingReply sortedArrayUsingDescriptors:sortDescriptors]];
		[keys addObject:@"Awaiting reply"];
	}
	if ([arrayOfAttending count] > 0) {
		[objects addObject:[arrayOfAttending sortedArrayUsingDescriptors:sortDescriptors]];
		[keys addObject:@"Attending"];
	}
	if ([arrayOfNotAttending count] > 0) {
		[objects addObject:[arrayOfNotAttending sortedArrayUsingDescriptors:sortDescriptors]];
		[keys addObject:@"Not Attending"];
	}
    if ([arrayOfOld count] > 0) {
        [objects addObject:[arrayOfOld sortedArrayUsingDescriptors:sortDescriptors]];
		[keys addObject:@"Old"];
    }
	
	self.tableDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	self.tableKeys = keys;
	
	[[super tableView] reloadData];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableKeys count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *meetingsInSection = [tableDictionary objectForKey:[tableKeys objectAtIndex:section]];
    return [meetingsInSection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [tableKeys objectAtIndex:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CustomCellIdentifier = @"MeetingCell";
	
	MeetingCell *cell = (MeetingCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeetingCell" owner:self options:nil];
		cell = (MeetingCell *)[nib objectAtIndex:0];
	}
    
	// Configure the cell...
	NSString *key = [tableKeys objectAtIndex:[indexPath section]];
	NSArray *arrayOfMeetings = [tableDictionary objectForKey:key];
	MeetingDTO *meeting = [arrayOfMeetings objectAtIndex:[indexPath row]];
	// Title
	cell.titleLabel.text = meeting.title;
	// Date and time
	NSDate *date = [DateFormatter dateFromString:meeting.time];
	cell.dateLabel.text = [NSDateFormatter localizedStringFromDate:date 
														 dateStyle:kCFDateFormatterLongStyle 
														 timeStyle:kCFDateFormatterNoStyle];
	NSString *time = [NSDateFormatter localizedStringFromDate:date 
													dateStyle:kCFDateFormatterNoStyle
													timeStyle:kCFDateFormatterShortStyle];
    cell.timeLabel.text = [NSString stringWithFormat:@"at %@", time];
	// Accepted and declined counters
	NSUInteger accepted = 0;
	NSUInteger declined = 0;
	for (AttendeeDTO *attendee in meeting.attendees) {
		if ([attendee.rsvp isEqualToString:kAttendingKey]) {
			accepted++;
		} else if ([attendee.rsvp isEqualToString:kNotAttendingKey]) {
			declined++;
		}
	}
	cell.acceptedAmountLabel.text = [NSString stringWithFormat:@"%u", accepted];
	cell.declinedAmountLabel.text = [NSString stringWithFormat:@"%u", declined];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Value of height from MeetingsViewController.xib
	return 69;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Get the meeting
	NSString *key = [tableKeys objectAtIndex:[indexPath section]];
	NSArray *arrayOfMeetings = [tableDictionary objectForKey:key];
	MeetingDTO *meeting = [arrayOfMeetings objectAtIndex:[indexPath row]];
	
	// Push it to the detail view
	[[[MeepAppDelegate sharedAppDelegate] menuNavigationController] showMeetingDetailView:meeting animated:YES];
}


#pragma mark -
#pragma mark MeetingsRequestManager

- (void)getMeetingsSuccessful:(NSArray *)meetings {
	
	// Only if the response is new (has not changed since previous request)
	if ([meetingsRequestManager isResponseNew]) {
		// Update the meetingsRelated stored against the currentUser in the application delegate.
		[[[MeepAppDelegate sharedAppDelegate] currentUser] setMeetingsRelated:meetings];
		[self updateTableWithMeetings:meetings];
	}
	
}

- (void)getMeetingsFailedWithError:(NSError *)error {
	//TODO
}

- (void)getMeetingsFailedWithNetworkError:(NSError *)error {
	[AlertView showNetworkAlert:error];
}


@end

