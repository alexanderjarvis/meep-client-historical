//
//  SearchUsersManager.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessTokenRequestManager.h"
#import "SearchUsersManagerDelegate.h"

@interface SearchUsersManager : AccessTokenRequestManager {
	id <SearchUsersManagerDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

- (void)searchUsers:(NSString *)searchString;

@end
