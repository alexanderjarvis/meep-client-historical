//
//  MeetingAttendeesViewController.m
//  Meep
//
//  Created by Alex Jarvis on 06/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "MeetingAttendeesViewController.h"

#import "MeepAppDelegate.h"
#import "UserDTO.h"

@implementation MeetingAttendeesViewController

@synthesize tableKeys;
@synthesize tableDictionary;
@synthesize meeting;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Attendees";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTableWithAttendees:meeting.attendees];
}

- (void)updateTableWithAttendees:(NSArray *)attendees {
	
	// Build up different sections of table
	NSMutableArray *arrayOfAwaitingReply = [NSMutableArray arrayWithCapacity:1];
	NSMutableArray *arrayOfAttending = [NSMutableArray arrayWithCapacity:1];
	NSMutableArray *arrayOfNotAttending = [NSMutableArray arrayWithCapacity:1];

    for (AttendeeDTO *attendee in meeting.attendees) {
        if (attendee.rsvp == nil) {
            [arrayOfAwaitingReply addObject:attendee];
        } else if ([attendee.rsvp isEqualToString:kAttendingKey]) {
            [arrayOfAttending addObject:attendee];
        } else if ([attendee.rsvp isEqualToString:kNotAttendingKey]) {
            [arrayOfNotAttending addObject:attendee];
        }
    }
	
	// Declare SortDescriptor to sort the attendees by name
	NSSortDescriptor *firstNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease];
    NSSortDescriptor *lastNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:firstNameDescriptor, lastNameDescriptor, nil];
	
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
#pragma mark Memory management

- (void)dealloc {
    [tableKeys release];
    [tableDictionary release];
    [meeting release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableKeys count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *attendeesInSection = [tableDictionary objectForKey:[tableKeys objectAtIndex:section]];
    return [attendeesInSection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [tableKeys objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *key = [tableKeys objectAtIndex:[indexPath section]];
	NSArray *arrayOfMeetings = [tableDictionary objectForKey:key];
	AttendeeDTO *attendee = [arrayOfMeetings objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", attendee.firstName, attendee.lastName];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
