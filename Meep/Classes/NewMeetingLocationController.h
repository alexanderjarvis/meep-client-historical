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

#import <Three20/Three20.h>

#import "MapLocation.h"

@interface NewMeetingLocationController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, UIAlertViewDelegate> {
	
	IBOutlet MKMapView *mapView;
	
	IBOutlet UIButton *chooseDateButton;

}

@property(nonatomic, retain) MKMapView *mapView;
@property(nonatomic, retain) UIButton *chooseDateButton;

- (IBAction)newPin;
- (IBAction)currentLocation;
- (IBAction)chooseDate;

- (void)removeAllAnnotations;

@end
