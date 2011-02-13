//
//  SearchUsersManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class SearchUsersManager;

@protocol SearchUsersManagerDelegate <NSObject>

@required

- (void)searchUsersSuccessful:(NSArray *)users;

- (void)searchUsersNotFound;

- (void)searchUsersFailedWithError:(NSError *)error;

- (void)searchUsersFailedWithNetworkError:(NSError *)error;

@end
