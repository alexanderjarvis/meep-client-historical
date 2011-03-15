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
        locationManager.distanceFilter = 0.5;
    }
    return self;
}

- (void)dealloc {
    [self stopUpdatingLocation];
    locationManager.delegate = nil;
    [locationManager release];
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
    
    // A negative value means that the reported heading is invalid
    if (newHeading.headingAccuracy < 0.0) {
        return;
    }
    
    BOOL postHeading = NO;
    
    if (currentHeading == nil) {
        currentHeading = [newHeading retain];
        postHeading = YES;
    
    // If the new heading is the same as the previous then don't update it.
    } else if (newHeading.trueHeading == currentHeading.trueHeading) {
        return;
    } else {
        currentHeading = [newHeading retain];
        postHeading = YES;
    }
    
    if (postHeading) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:currentHeading forKey:kHeadingUpdateNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHeadingUpdateNotification object:self userInfo:dictionary];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
        
    // Ignore old locations
    NSTimeInterval locationAge = [newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) {
        return;
    }
    
    // "A negative value indicates that the location’s latitude and longitude are invalid."
    if (newLocation.horizontalAccuracy < 0.0) {
        return;
    }
    
    BOOL postLocation = NO;
    
    // If bestCurrentLocation has not been set yet, or if the new location has a higher accuracy.
    if (currentLocation == nil) {
        currentLocation = [newLocation retain];
        postLocation = YES;
    
    // If the new location is the same as the previous, then don't update it.
    } else if (newLocation.coordinate.latitude == currentLocation.coordinate.latitude && 
               newLocation.coordinate.longitude == currentLocation.coordinate.longitude) {
        return;
    
    // If the horizontal accuracy is the same or better than previously
    // or if the horizontal accuracy is the same or better than 10 metres
    } else if (newLocation.horizontalAccuracy <= currentLocation.horizontalAccuracy || 
               newLocation.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters) {
        currentLocation = [newLocation retain];
        postLocation = YES;
    }
    
    if (postLocation) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:currentLocation forKey:kLocationUpdateNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdateNotification object:self userInfo:dictionary];
    }
    
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
