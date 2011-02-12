//
//  User.h
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	
	NSString *_id;
	NSString *accessToken;
	NSString *email;
	NSString *firstName;
	NSString *lastName;
	NSString *mobileNumber;
	NSArray *connections;
	
}

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, retain) NSArray *connections;

@end
