//
//  SearchUsersViewController.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchUsersViewController : UITableViewController <UISearchBarDelegate> {
	
	IBOutlet UISearchDisplayController *searchDisplayController;
	
	NSArray *users;

}

@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@property (nonatomic, retain) NSArray *users;

@end
