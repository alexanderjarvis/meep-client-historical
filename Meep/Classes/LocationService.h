//
//  LocationService.h
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    NSMutableArray *locations;
    CLLocation *currentLocation;
    CLHeading *currentHeading;
}

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLHeading *currentHeading;

- (id)init;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@end
