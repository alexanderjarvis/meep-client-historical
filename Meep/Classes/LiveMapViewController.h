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

@interface LiveMapViewController : UIViewController {
    
    LocationService *locationService;
    
    IBOutlet MKMapView *mapView;
    IBOutlet UIButton *backButton;
    
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIButton *backButton;

- (void)locationUpdated:(NSNotification *)notification;

@end
