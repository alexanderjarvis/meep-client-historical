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
}

@end
