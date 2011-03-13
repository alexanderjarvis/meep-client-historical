    //
//  LocationService.m
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationService.h"

#import "MeepNotificationCenter.h"

@implementation LocationService

@synthesize currentLocation;
@synthesize currentHeading;

- (id)init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 5;
        locations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self stopUpdatingLocation];
    locationManager.delegate = nil;
    [locationManager release];
    [locations release];
    [currentLocation release];
    [currentHeading release];
    [super dealloc];
}

- (void)startUpdatingLocation {
    [locationManager startUpdatingLocation];
    if ([CLLocationManager headingAvailable]) {
        [locationManager startUpdatingHeading];
    }
}

- (void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
    [locationManager stopUpdatingHeading];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:error forKey:kLocationErrorNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationErrorNotification object:self userInfo:dictionary];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    // Ignore old headings
    NSTimeInterval headingAge = [newHeading.timestamp timeIntervalSinceNow];
    if (headingAge > 5.0) {
        return;
    }
    if (currentHeading == nil) {
        self.currentHeading = newHeading;
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:currentHeading forKey:kHeadingUpdateNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHeadingUpdateNotification object:self userInfo:dictionary];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // Add to locations array for tracing
    [locations addObject:newLocation];
    
    // Ignore old locations
    NSTimeInterval locationAge = [newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) {
        return;
    }
    
    // If bestCurrentLocation has not been set yet, or if the new location has a higher accuracy.
    if (currentLocation == nil) {
        self.currentLocation = newLocation;
    } else if (newLocation.horizontalAccuracy < currentLocation.horizontalAccuracy) {
        self.currentLocation = newLocation;
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[currentLocation copy] forKey:kLocationUpdateNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdateNotification object:self userInfo:dictionary];
        
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
}

/*
 * This alert is usually annoying for users and the documentation states that calibration will occur naturally anyhow:
 *
 * "Even if the alert is not displayed, calibration can still occur naturally when any interfering magnetic fields 
 * move away from the device."
 *
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return NO;
}

@end
