//
//  UsersViewController.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserManager.h"
#import "User.h"

@interface UsersViewController : UITableViewController <UserManagerDelegate> {
	
	UserManager *userManager;
	
	NSArray *tableKeys;
	NSDictionary *tableDictionary;

}

@property(nonatomic, retain) UserManager *userManager;

@property(nonatomic, retain) NSArray *tableKeys;
@property(nonatomic, retain) NSDictionary *tableDictionary;

- (void)updateTableWithUser:(User *)user;

@end
