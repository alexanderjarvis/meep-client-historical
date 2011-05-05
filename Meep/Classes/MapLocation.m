//
//  MapLocation.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

@synthesize streetAddress;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize coordinate;

#pragma mark -

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.coordinate = newCoordinate;
	return self;
}

- (NSString *)title {
	return @"Meeting Location";
}

- (NSString *)subtitle {
	NSMutableString *ret = [NSMutableString string];
	if (streetAddress) {
		[ret appendString:streetAddress];
	}
	if (streetAddress && (city || state || zip)) {
		[ret appendString:@" • "];
	}
	if (city) {
		[ret appendString:city];
	}
	if (city && state) {
		[ret appendString:@", "];
	}
	if (state) {
		[ret appendString:state];
	}
	if (zip) {
		[ret appendFormat:@", %@", zip];
	}
	
	return ret;
}

- (void)resetReverseGeocodeAttributes {
	self.streetAddress = nil;
	self.city = nil;
	self.state = nil;
	self.zip = nil;
}

#pragma mark -
- (void)dealloc {
	[streetAddress release];
	[city release];
	[state release];
	[zip release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject: [self streetAddress] forKey: kStreetAddress];
	[encoder encodeObject: [self city] forKey: kCity];
	[encoder encodeObject: [self state] forKey: kState];
	[encoder encodeObject: [self zip] forKey: kZip];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
	if (self) {
		[self setStreetAddress: [decoder decodeObjectForKey:kStreetAddress]];
		[self setCity: [decoder decodeObjectForKey:kCity]];
		[self setState: [decoder decodeObjectForKey:kState]];
		[self setZip: [decoder decodeObjectForKey:kZip]];
	}
	return self;
}

@end
