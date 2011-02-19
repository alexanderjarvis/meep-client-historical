//
//  User.h
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	
	NSNumber *_id;
	NSString *accessToken;
	NSString *email;
	NSString *firstName;
	NSString *lastName;
	NSString *mobileNumber;
	NSArray *connections;
	User *_type_connections;
	NSArray *connectionRequestsTo;
	User *_type_connectionRequestsTo;
	NSArray *connectionRequestsFrom;
	User *_type_connectionRequestsFrom;
}

@property (nonatomic, copy) NSNumber *_id;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, retain) NSArray *connections;
@property (nonatomic, retain) User *_type_connections;
@property (nonatomic, retain) NSArray *connectionRequestsTo;
@property (nonatomic, retain) User *_type_connectionRequestsTo;
@property (nonatomic, retain) NSArray *connectionRequestsFrom;
@property (nonatomic, retain) User *_type_connectionRequestsFrom;

-(id)init;

@end
