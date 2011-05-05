//
//  User.h
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserSummaryDTO.h"
#import "MeetingDTO.h"

@interface UserDTO : NSObject {
	
	NSNumber *_id;
	NSString *accessToken;
	NSString *email;
    NSString *password;
	NSString *firstName;
	NSString *lastName;
	NSString *mobileNumber;
	NSArray *connections;
	UserSummaryDTO *_type_connections;
	NSArray *connectionRequestsTo;
	UserSummaryDTO *_type_connectionRequestsTo;
	NSArray *connectionRequestsFrom;
	UserSummaryDTO *_type_connectionRequestsFrom;
	NSArray *meetingsRelated;
	MeetingDTO *_type_meetingsRelated;
    
}

@property (nonatomic, copy) NSNumber *_id;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, retain) NSArray *connections;
@property (nonatomic, retain) UserSummaryDTO *_type_connections;
@property (nonatomic, retain) NSArray *connectionRequestsTo;
@property (nonatomic, retain) UserSummaryDTO *_type_connectionRequestsTo;
@property (nonatomic, retain) NSArray *connectionRequestsFrom;
@property (nonatomic, retain) UserSummaryDTO *_type_connectionRequestsFrom;
@property (nonatomic, retain) NSArray *meetingsRelated;
@property (nonatomic, retain) MeetingDTO *_type_meetingsRelated;

- (id)init;

@end
