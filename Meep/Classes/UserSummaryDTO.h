//
//  UserSummaryDTO.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserSummaryDTO : NSObject {
	
	NSNumber *_id;
	NSString *email;
	NSString *firstName;
	NSString *lastName;
	NSString *mobileNumber;
	
}

@property (nonatomic, copy) NSNumber *_id;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *mobileNumber;

@end
