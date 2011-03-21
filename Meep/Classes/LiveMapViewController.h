//
//  LiveMapViewController.h
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "LocationService.h"
#import "CurrentUserAnnotation.h"
#import "WebSocketManager.h"
#import "MeetingDTO.h"

@interface LiveMapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate> {
    
    UIBarButtonItem *enableLocationButton;
    UIBarButtonItem *disableLocationButton;
    UIAlertView *enableLocationUpdatesAlertView;
    UIAlertView *disableLocationUpdatesAlertView;
    
    LocationService *locationService;
    
    IBOutlet MKMapView *mapView;
    
    BOOL firstLocationUpdate;
    CurrentUserAnnotation *currentUserAnnotation;
    NSMutableArray *meetingPlaceAnnotations;
    NSMutableArray *otherUserAnnotations;
    
    WebSocketManager *webSocketManager;
    
    CLHeading *currentHeading;
    CLLocation *currentLocation;
    CLLocation *previousLocation;
    
    MeetingDTO *currentMeeting;
    
}

@property (nonatomic, retain) MKMapView *mapView;

- (void)setCurrentMeeting:(MeetingDTO *)currentMeeting;

- (IBAction)myLocationButtonPressed;
- (IBAction)showAllAnnotationsButtonPressed;

@end
