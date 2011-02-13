//
//  SearchUsersViewController.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchUsersViewController : UITableViewController <UISearchBarDelegate> {
	
	IBOutlet UITableView *tableView;
	IBOutlet UISearchDisplayController *searchDisplayController;
	
	NSArray *users;

}

@property(nonatomic,retain) UITableView *tableView;

@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@property (nonatomic, retain) NSArray *users;

@end
