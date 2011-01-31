//
//  NewMeetingLocationController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MapLocation.h"

@interface NewMeetingLocationController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate> {
	
	IBOutlet MKMapView *mapView;
	
	MapLocation *meetingLocation;

}

@property(nonatomic, retain) MKMapView *mapView;

- (IBAction)newPin;
- (IBAction)currentLocation;
- (IBAction)chooseDate;

@end
