//
//  LiveMapViewController.h
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Three20/Three20.h>

#import "LocationService.h"
#import "CurrentUserAnnotation.h"
#import "WebSocketManager.h"
#import "MeetingDTO.h"

#define kAnnotationTimerKey @"AnnotationTimer"

// Walking speed in m/s constant, to calculate ETA from meeting.
// based on 5km/hour as the average walking speed.
static const double walkingSpeed = (5000 / 60 / 60);

@interface LiveMapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate> {
    
    UIBarButtonItem *enableLocationButton;
    UIBarButtonItem *disableLocationButton;
    UIAlertView *enableLocationUpdatesAlertView;
    UIAlertView *disableLocationUpdatesAlertView;
    
    LocationService *locationService;
    
    IBOutlet MKMapView *_mapView;
    
    BOOL firstLocationUpdate;
    CurrentUserAnnotation *currentUserAnnotation;
    NSMutableArray *meetingPlaceAnnotations;
    NSMutableArray *otherUserAnnotations;
    NSUInteger selectedAnnotationIndex;
    id<MKAnnotation> selectedAnnotation;
    
    WebSocketManager *webSocketManager;
    
    CLHeading *currentHeading;
    CLLocation *currentLocation;
    CLLocation *previousLocation;
    
    MeetingDTO *currentMeeting;
    
    NSTimer *annotationUpdateTimer;
    
}

@property (nonatomic, retain) MKMapView *mapView;

- (void)setCurrentMeeting:(MeetingDTO *)currentMeeting;

- (IBAction)myLocationButtonPressed;
- (IBAction)showAllAnnotationsButtonPressed;
- (IBAction)nextAnnotationButtonPressed;
- (IBAction)previousAnnotationButtonPressed;

@end
