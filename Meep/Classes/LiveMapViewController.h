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

@interface LiveMapViewController : UIViewController <MKMapViewDelegate> {
    
    LocationService *locationService;
    
    IBOutlet MKMapView *mapView;
    
    BOOL firstLocationUpdate;
    NSMutableArray *meetingPlaceAnnotations;
    NSMutableArray *otherUserAnnotations;
    
    WebSocketManager *webSocketManager;
    
    CLHeading *currentHeading;
    CLLocation *currentLocation;
    CLLocation *previousLocation;
    
}

@property (nonatomic, retain) MKMapView *mapView;

@end
