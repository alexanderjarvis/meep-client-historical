//
//  UserLocationDTO.h
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoordinateDTO.h"

@interface UserLocationDTO : NSObject {
    
    NSString *time;
    CoordinateDTO *coordinate;
    NSNumber *speed;
    NSNumber *altitude;
    NSNumber *trueHeading;
    NSNumber *verticalAccuracy;
    NSNumber *horizontalAccuracy;
    
}

@property (nonatomic, copy) NSString *time;
@property (nonatomic, retain) CoordinateDTO *coordinate;
@property (nonatomic, copy) NSNumber *speed;
@property (nonatomic, copy) NSNumber *altitude;
@property (nonatomic, copy) NSNumber *trueHeading;
@property (nonatomic, copy) NSNumber *verticalAccuracy;
@property (nonatomic, copy) NSNumber *horizontalAccuracy;

- (id)init;

@end
