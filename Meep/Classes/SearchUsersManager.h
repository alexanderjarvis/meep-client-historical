//
//  SearchUsersManager.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SearchUsersManagerDelegate.h"

@interface SearchUsersManager : NSObject {
	id <SearchUsersManagerDelegate> delegate;
	
	NSString *accessToken;
}

@property (assign, nonatomic) id delegate;
@property (nonatomic, copy) NSString *accessToken;

- (id)initWithAccessToken:(NSString *)accessToken;
- (void)searchUsers:(NSString *)searchString;

@end
