//
//  NewMeetingLocationController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMeetingLocationController.h"
#import "MeepAppDelegate.h"
#import "MeepStyleSheet.h"
#import "AlertView.h"
#import "NewMeetingBuilder.h"

@implementation NewMeetingLocationController

@synthesize mapView;
@synthesize newPinButton;
@synthesize currentLocationButton;
@synthesize chooseDateButton;

- (void)viewDidLoad {
	self.title = @"Place";
	
	[TTStyleSheet setGlobalStyleSheet:[[[MeepStyleSheet alloc] init] autorelease]];
	
	// New Pin button
	TTButton *button = [TTButton buttonWithStyle:@"toolbarButton:" title:@"New Pin"];
	[button sizeToFit];
	[button addTarget:self action:@selector(newPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[newPinButton addSubview:button];
	
	// Current Location button
	 button = [TTButton buttonWithStyle:@"toolbarButton:" title:@"Current Location"];
	[button sizeToFit];
	[button addTarget:self action:@selector(currentLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[currentLocationButton addSubview:button];
	
	// Choose Date & Time button
	button = [TTButton buttonWithStyle:@"blackForwardButton:" title:@"Choose Date & Time"];
	button.font = [UIFont boldSystemFontOfSize:13];
	[button sizeToFit];
	[button addTarget:self action:@selector(chooseDateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[chooseDateButton addSubview:button];
	
    [super viewDidLoad];
}

- (void)newPinButtonPressed {
	NSLog(@"New Pin button pressed");
	
	[self removeAllAnnotations];
	
	MapLocation *meetingLocation = [[MapLocation alloc] initWithCoordinate:mapView.centerCoordinate];
	[mapView addAnnotation:meetingLocation];
	[meetingLocation release];
	[self reverseGeocodeCoordinate:mapView.centerCoordinate];
}

- (void)currentLocationButtonPressed {
	NSLog(@"Current Location button pressed");
	
	if (locationManager == nil) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	[locationManager startUpdatingLocation];
	
	NSLog(@"Started Updating location");
}

- (void)chooseDateButtonPressed {
	NSLog(@"Choose Date & Time button pressed");
	
	if ([mapView.annotations count] > 0) {
		
		// Build up meeting information
		MapLocation *meetingLocation = [[mapView annotations] objectAtIndex:0];
		CLLocationCoordinate2D coordinate = [meetingLocation coordinate];
		
		MeetingDTO *meetingDTO = [[NewMeetingBuilder sharedNewMeetingBuilder] meetingDTO];
		meetingDTO.place.latitude = [NSNumber numberWithDouble:coordinate.latitude];
		meetingDTO.place.longitude = [NSNumber numberWithDouble:coordinate.longitude];
		
		// Show date & time view
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[meepAppDelegate.menuNavigationController showNewMeetingDateAndTime];
		
	} else {
		[AlertView showValidationAlert:@"You must choose a meeting location first."];
	}

}

- (void)openCallout:(id<MKAnnotation>)annotation {
	[mapView selectAnnotation:annotation animated:YES];
}

- (void)removeAllAnnotations {
	if ([mapView.annotations count] > 0) {
		[mapView removeAnnotations:mapView.annotations];
	}
}

- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate {
	NSLog(@"Reverse Geocoding Location");
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	geocoder.delegate = self;
	[geocoder start];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapView release];
	[newPinButton release];
	[currentLocationButton release];
	[chooseDateButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Map View Delegate Methods
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView 
							     didChangeDragState:(MKAnnotationViewDragState)newState 
									   fromOldState:(MKAnnotationViewDragState)oldState {
	MapLocation *meetingLocation = annotationView.annotation;
	if ([meetingLocation isKindOfClass:[MapLocation class]]) {
		if (oldState == MKAnnotationViewDragStateDragging && newState == MKAnnotationViewDragStateEnding) {
			[meetingLocation resetReverseGeocodeAttributes];
			[self reverseGeocodeCoordinate:annotationView.annotation.coordinate];
		}
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	static NSString *placemarkIdentifier = @"Map Location Identifier";
	
	if ([annotation isKindOfClass:[MapLocation class]]) {
		MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[theMapView 
																	  dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
		
		if (annotationView == nil) {
			annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation 
															 reuseIdentifier:placemarkIdentifier];
		} else {
			annotationView.annotation = annotation;
		}
		annotationView.enabled = YES;
		annotationView.animatesDrop = YES;
		annotationView.pinColor = MKPinAnnotationColorRed;
		annotationView.canShowCallout = YES;
		annotationView.draggable = YES;
		[self performSelector:@selector(openCallout:) withObject:annotation afterDelay:0.5];
		
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

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
	if ([newLocation.timestamp timeIntervalSince1970] <
		[NSDate timeIntervalSinceReferenceDate] - 60) {
		return;
	}
	
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
	MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
	[mapView setRegion:adjustedRegion animated:YES];
	
	[manager stopUpdatingLocation];
	
	// Add current location as annotation.
	[self removeAllAnnotations];
	MapLocation *meetingLocation = [[MapLocation alloc] initWithCoordinate:newLocation.coordinate];
	[mapView addAnnotation:meetingLocation];
	[meetingLocation release];
	[self reverseGeocodeCoordinate:newLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting location"
													message:errorType
												   delegate:self
										  cancelButtonTitle:@"Okay" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[manager release];
}

#pragma mark -
#pragma mark Reverse Geocoder Methods
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	NSLog(@"Geocoder did not recognize coordinates");
	
	geocoder.delegate = nil;
	[geocoder autorelease];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSLog(@"Location Determined");
	
	if ([[mapView annotations] count] == 1) {
		MapLocation *meetingLocation = [[mapView annotations] objectAtIndex:0];
		if ([meetingLocation isKindOfClass:[MapLocation class]]) {
			meetingLocation.streetAddress = placemark.thoroughfare;
			meetingLocation.city = placemark.locality;
			meetingLocation.state = placemark.administrativeArea;
			meetingLocation.zip = placemark.postalCode;
		}
	}	
	geocoder.delegate = nil;
	[geocoder autorelease];
}



@end
