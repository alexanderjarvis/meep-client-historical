//
//  OtherUserAnnotation.h
//  Meep
//
//  Created by Alex Jarvis on 14/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserAnnotation.h"

@interface OtherUserAnnotation : UserAnnotation {
    
    NSNumber *_id;
    NSMutableArray *locationHistory;
    
}

@property (nonatomic, retain) NSNumber *_id;
@property (nonatomic, retain) NSMutableArray *locationHistory;

@end
