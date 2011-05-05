//
//  UserRequestsCustomCell.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

#import "UserRequestsViewController.h"

@interface UserRequestsCustomCell : UITableViewCell <UIAlertViewDelegate> {
	
	UserRequestsViewController *userRequestsViewController;
	NSIndexPath *indexPath;

}

@property (nonatomic, assign) UserRequestsViewController *userRequestsViewController;
@property (nonatomic, retain) NSIndexPath *indexPath;

-(void)respondButtonPressed;

@end
