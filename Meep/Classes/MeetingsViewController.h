//
//  MeetingsViewController.h
//  Meep
//
//  Created by Alex Jarvis on 02/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeetingsRequestManager.h"

@interface MeetingsViewController : UITableViewController {
	
	MeetingsRequestManager *meetingsRequestManager;
	
	NSArray *tableKeys;
	NSDictionary *tableDictionary;
}

@property (nonatomic, retain) NSArray *tableKeys;
@property (nonatomic, retain) NSDictionary *tableDictionary;

- (void)updateTableWithMeetings:(NSArray *)meetings;

@end
