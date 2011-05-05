//
//  UsersViewController.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UsersRequestManager.h"
#import "UserDTO.h"

@interface UsersViewController : UITableViewController <UsersRequestManagerDelegate> {
	
	UsersRequestManager *usersRequestManager;
	
	NSArray *tableKeys;
	NSDictionary *tableDictionary;

}

@property(nonatomic, retain) UsersRequestManager *usersRequestManager;

@property(nonatomic, retain) NSArray *tableKeys;
@property(nonatomic, retain) NSDictionary *tableDictionary;

- (void)updateTableWithUsers:(NSArray *)users;

@end
