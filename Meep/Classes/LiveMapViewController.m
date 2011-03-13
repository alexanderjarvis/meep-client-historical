//
//  LiveMapViewController.m
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LiveMapViewController.h"

#import "MeepNotificationCenter.h"

@implementation LiveMapViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        firstLocationUpdate = YES;
    }
    return self;
}

- (void)dealloc {
    [locationService release];
    [mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MeepNotificationCenter sharedNotificationCenter] addObserverForLocationUpdates:self selector:@selector(locationUpdated:)];
    
    locationService = [[LocationService alloc] init];
    [locationService startUpdatingLocation];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark LocationService

- (void)locationUpdated:(NSNotification *)notification {
    CLLocation *currentLocation = [[notification userInfo] objectForKey:kLocationUpdateNotification];
    NSLog(@"latitude: %f", currentLocation.coordinate.latitude);
    NSLog(@"longitude: %f", currentLocation.coordinate.longitude);
    
    // Update the maps region on the 1st location update.
    if (firstLocationUpdate) {
        firstLocationUpdate = NO;
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 500, 500) animated:YES];
    
    } else {
    
        // Remove the previous annotation
        for (NSObject<MKAnnotation> *annotation in mapView.annotations) {
            if ([annotation isKindOfClass:[CurrentUserAnnotation class]]) {
                [annotation setCoordinate:currentLocation.coordinate];
                [mapView removeAnnotation:annotation];
            }
        }
    }
    
    // Add the current users annotation
    currentUserAnnotation = [[[CurrentUserAnnotation alloc] init] autorelease];
    currentUserAnnotation.coordinate = currentLocation.coordinate;
    currentUserAnnotation.title = @"Me";
    [mapView addAnnotation:currentUserAnnotation];
    
    // Set the maps center coordinate to current users location and retain the region span
    [mapView setRegion:MKCoordinateRegionMake(currentLocation.coordinate, mapView.region.span) animated:YES];
    
}

#pragma mark -
#pragma mark MapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	// If the Current User Annotation
	if ([annotation isKindOfClass:[CurrentUserAnnotation class]]) {
        static NSString *currentUserLocationIdentifier = @"Current User Location Identifier";
		MKAnnotationView *annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:currentUserLocationIdentifier];
		
		if (annotationView == nil) {
			annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation 
															 reuseIdentifier:currentUserLocationIdentifier];
            annotationView.image = [UIImage imageNamed:@"bluemarble.png"];
		} else {
			annotationView.annotation = annotation;
		}
		annotationView.enabled = YES;
		annotationView.canShowCallout = YES;
		
		return annotationView;		
	}
    
    return nil;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error loading map"
													message:[error localizedDescription]
												   delegate:nil
										  cancelButtonTitle:@"Okay"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
