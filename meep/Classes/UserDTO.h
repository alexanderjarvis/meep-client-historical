//
//  UserDTO.h
//  meep
//
//  Created by Alex Jarvis on 27/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDTO : NSObject {
	
	NSString *email;
	NSString *password;
	NSString *firstName;
	NSString *lastName;
	NSString *userName;
	NSString *mobileNumber;

}

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *mobileNumber;

-(NSString *)paramString;

@end
