//
//  UserSummary.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSummary : NSObject {
	
	NSString *_id;
	NSString *email;
	NSString *firstName;
	NSString *lastName;
	NSString *mobileNumber;
	
}

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *mobileNumber;

@end
