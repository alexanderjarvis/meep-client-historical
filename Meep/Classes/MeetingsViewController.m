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
#import "ISO8601DateFormatter.h"

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
    meetingsRequestManager = [[MeetingsRequestManager alloc] initWithAccessToken:configManager.access_token];
	[meetingsRequestManager setDelegate:self];
	
	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	MeepAppDelegate *meepAppDelegate = [MeepAppDelegate sharedAppDelegate];
	[self updateTableWithMeetings:[[meepAppDelegate currentUser] meetingsRelated]];
	
	// Get the meetings
	[meetingsRequestManager getMeetings];
}

- (void)updateTableWithMeetings:(NSArray *)meetings {
	
	// Build up different sections of table
	NSMutableArray *arrayOfAwaitingReply = [NSMutableArray arrayWithCapacity:1];
	NSMutableArray *arrayOfAttending = [NSMutableArray arrayWithCapacity:1];
	NSMutableArray *arrayOfNotAttending = [NSMutableArray arrayWithCapacity:1];
	
	User *currentUser = [[MeepAppDelegate sharedAppDelegate] currentUser];
	for (MeetingDTO *meetingDTO in meetings) {
		for (AttendeeDTO *attendeeDTO in meetingDTO.attendees) {
			if ([attendeeDTO._id isEqualToNumber:currentUser._id]) {
				if (attendeeDTO.rsvp == nil) {
					[arrayOfAwaitingReply addObject:meetingDTO];
				} else if ([attendeeDTO.rsvp isEqualToString:@"YES"]) {
					[arrayOfAttending addObject:meetingDTO];
				} else if ([attendeeDTO.rsvp isEqualToString:@"NO"]) {
					[arrayOfNotAttending addObject:meetingDTO];
				}
				// Stop iterating attendees when the current user is reached
				break;
			}
		}
	}
	
	// Declare SortDescriptor to sort the sections by ascending date
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	// Only add sections if they are not empty.
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:3];
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:3];
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
	
	self.tableDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	self.tableKeys = keys;
	
	[[super tableView] reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [tableKeys count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSArray *meetingsInSection = [tableDictionary objectForKey:[tableKeys objectAtIndex:section]];
    return [meetingsInSection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [tableKeys objectAtIndex:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
    
	static NSString *CustomCellIdentifier = @"MeetingCell";
	
	MeetingCell *cell = (MeetingCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeetingCell" owner:self options:nil];
		cell = (MeetingCell *)[nib objectAtIndex:0];
	}
    
	// Configure the cell...
	NSString *key = [tableKeys objectAtIndex:section];
	NSArray *arrayOfMeetings = [tableDictionary objectForKey:key];
	MeetingDTO *meetingDTO = [arrayOfMeetings objectAtIndex:row];
	// Title
	cell.titleLabel.text = meetingDTO.title;
	// Date and time
	NSDate *date = [ISO8601DateFormatter dateFromString:meetingDTO.time];
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
	for (AttendeeDTO *attendeeDTO in meetingDTO.attendees) {
		if ([attendeeDTO.rsvp isEqualToString:@"YES"]) {
			accepted++;
		} else if ([attendeeDTO.rsvp isEqualToString:@"NO"]) {
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
	return 69;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
#pragma mark MeetingsRequestManager

- (void)getMeetingsSuccessful:(NSArray *)meetings {
	
	// Only if the response is new (has not changed since previous request)
	if ([meetingsRequestManager isResponseNew]) {
		// Update the meetingsRelated stored against the currentUser in the application delegate.
		[[[MeepAppDelegate sharedAppDelegate] currentUser] setMeetingsRelated:meetings];
		
	}
	
}

- (void)getMeetingsFailedWithError:(NSError *)error {
	//TODO
}

- (void)getMeetingsFailedWithNetworkError:(NSError *)error {
	[AlertView showNetworkAlert:error];
}


@end

