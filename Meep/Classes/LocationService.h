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
    CLLocation *currentLocation;
    CLHeading *currentHeading;
}

@property (nonatomic, assign) CLLocation *currentLocation;
@property (nonatomic, assign) CLHeading *currentHeading;

- (id)init;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@end
