//
//  RecentUserLocationsDTO.h
//  Meep
//
//  Created by Alex Jarvis on 14/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserLocationDTO.h"

@interface RecentUserLocationsDTO : NSObject {
    
    NSNumber *_id;
    NSString *firstName;
    NSString *lastName;
    NSArray *locationHistory;
    UserLocationDTO *_type_locationHistory;
}

@property (nonatomic, copy) NSNumber *_id;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, retain) NSArray *locationHistory;
@property (nonatomic, retain) UserLocationDTO *_type_locationHistory;

@end
