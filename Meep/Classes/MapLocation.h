//
//  MapLocation.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define kStreetAddress @"streetAddress"
#define kCity @"city"
#define kState @"state"
#define kZip @"zip"

@interface MapLocation : NSObject <MKAnnotation, NSCoding> {
	NSString *streetAddress;
	NSString *city;
	NSString *state;
	NSString *zip;
	
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (void)resetReverseGeocodeAttributes;

@end
