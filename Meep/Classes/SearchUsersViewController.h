//
//  SearchUsersViewController.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchUsersManager.h"

@interface SearchUsersViewController : UITableViewController <SearchUsersManagerDelegate, UISearchBarDelegate> {
	
	SearchUsersManager *searchUsersManager;
	IBOutlet UISearchDisplayController *searchDisplayController;
	NSArray *users;

}

@property (nonatomic, retain) SearchUsersManager *searchUsersManager;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) NSArray *users;

@end
