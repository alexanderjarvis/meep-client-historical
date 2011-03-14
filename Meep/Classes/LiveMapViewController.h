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
    CurrentUserAnnotation *currentUserAnnotation;
    NSMutableArray *otherUserAnnotations;
    
    WebSocketManager *webSocketManager;
    
}

@property (nonatomic, retain) MKMapView *mapView;

- (void)locationUpdated:(NSNotification *)notification;

- (void)newLocationsFromSocket:(NSNotification *)notification;

@end
