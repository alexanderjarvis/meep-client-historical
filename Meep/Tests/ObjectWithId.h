//
//  ObjectWithId.h
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ObjectWithId : NSObject {
	
	NSNumber *_id;

}

@property (nonatomic, copy) NSNumber *_id;

@end
