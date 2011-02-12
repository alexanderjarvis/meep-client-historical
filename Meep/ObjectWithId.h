//
//  ObjectWithId.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ObjectWithId : NSObject <NSCopying> {
	
	NSString *_id;

}

@property (nonatomic, copy) NSString *_id;

@end
