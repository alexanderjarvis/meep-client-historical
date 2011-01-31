//
//  MenuViewController.m
//  meep
//
//  Created by Alex Jarvis on 16/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

#import "MeepAppDelegate.h"

@implementation MenuViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
	self.title = @"Menu";
	
	launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	launcherView.backgroundColor = [UIColor blackColor];
	launcherView.delegate = self;
	launcherView.columnCount = 3;
	
	TTLauncherItem* item =
	[[TTLauncherItem alloc] initWithTitle: @"Meetings"
									image: @"bundle://Icon.png"
									  URL: @"mp://meetings"];
	[launcherView addItem:item animated:NO];
	
	item =
	[[TTLauncherItem alloc] initWithTitle: @"People"
									image: @"bundle://Icon.png"
									  URL: @"mp://people"];
	[launcherView addItem:item animated:NO];
	
	item =
	[[TTLauncherItem alloc] initWithTitle: @"New Meeting"
									image: @"bundle://Icon.png"
									  URL: NewMeetingURL];
	[launcherView addItem:item animated:NO];
	
	item =
	[[TTLauncherItem alloc] initWithTitle: @"My Details"
									image: @"bundle://Icon.png"
									  URL: @"mp://mydetails"];
	[launcherView addItem:item animated:NO];
	
	//item.badgeNumber = 7;
	TT_RELEASE_SAFELY(item);
	[self.view addSubview:launcherView];
	
	[super viewDidLoad];
}

#pragma mark -
#pragma mark TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	NSLog(@"Item selected");
	
	MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
	
	if ([item.URL isEqualToString:NewMeetingURL]) {
		NSLog(@"New meeting");
		[meepAppDelegate.menuNavigationController showNewMeeting];
	}
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	//[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
	//											 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	//											 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	//[self.navigationItem setRightBarButtonItem:nil animated:YES];
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
    [super dealloc];
}


@end

