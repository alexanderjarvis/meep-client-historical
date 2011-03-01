//
//  NewMeetingLocationController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MapLocation.h"

@interface NewMeetingLocationController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, UIAlertViewDelegate> {
	
	IBOutlet MKMapView *mapView;
	
	IBOutlet UIButton *newPinButton;
	IBOutlet UIButton *currentLocationButton;
	IBOutlet UIButton *chooseDateButton;
	
	CLLocationManager *locationManager;

}

@property(nonatomic, retain) MKMapView *mapView;
@property(nonatomic, retain) UIButton *newPinButton;
@property(nonatomic, retain) UIButton *currentLocationButton;
@property(nonatomic, retain) UIButton *chooseDateButton;

- (void)newPinButtonPressed;
- (void)currentLocationButtonPressed;
- (void)chooseDateButtonPressed;

- (void)removeAllAnnotations;
- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate;

@end
