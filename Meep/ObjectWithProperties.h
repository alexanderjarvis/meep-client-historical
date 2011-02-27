//
//  ObjectWithProperties.h
//  Meep
//
//  Created by Alex Jarvis on 27/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectWithProperties : NSObject {
	
	NSNumber *_id;
	NSString *firstName;
	NSString *lastName;

}

@property (nonatomic, copy) NSNumber *_id;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end
