//
//  NewMeetingLocationController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMeetingLocationController.h"

#import "MeepAppDelegate.h"

@implementation NewMeetingLocationController

@synthesize mapView;

- (void)viewDidLoad {
	self.title = @"Place";
	
    [super viewDidLoad];
}

- (IBAction)newPin {
	NSLog(@"New Pin button pressed");
	
	[self removeAllAnnotations];
	
	MapLocation *meetingLocation = [[MapLocation alloc] initWithCoordinate:mapView.centerCoordinate];
	[mapView addAnnotation:meetingLocation];
	[meetingLocation release];
}

- (IBAction)currentLocation {
	NSLog(@"Current Location button pressed");
	
	CLLocationManager *lm = [[CLLocationManager alloc] init];
	lm.delegate = self;
	lm.desiredAccuracy = kCLLocationAccuracyBest;
	[lm startUpdatingLocation];
	
	NSLog(@"Started Updating location");
	//TODO: activity view
}

- (IBAction)chooseDate {
	NSLog(@"Choose Date & Time button pressed");
	
	if ([mapView.annotations count] > 0) {
		
		MeepAppDelegate *meepAppDelegate = [[UIApplication sharedApplication] delegate];
		[meepAppDelegate.menuNavigationController showNewMeetingDateAndTime];
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
														message:@"You must choose a meeting location first."
													   delegate:nil
											  cancelButtonTitle:@"Okay"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
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
    [super dealloc];
}

#pragma mark -
#pragma mark Map View Delegate Methods
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
	
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
	MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
	[mapView setRegion:adjustedRegion animated:YES];
	
	manager.delegate = nil;
	[manager stopUpdatingLocation];
	[manager autorelease];
	
	NSLog(@"Reverse Geocoding Location");
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	geocoder.delegate = self;
	[geocoder start];
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
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error translating coordinates into location"																			  
													message:@"Geocoder did not recognize coordinates"
												   delegate:self
										  cancelButtonTitle:@"Okay"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	geocoder.delegate = nil;
	[geocoder autorelease];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSLog(@"Location Determined");
	
	[self removeAllAnnotations];
	
	MapLocation *meetingLocation = [[MapLocation alloc] initWithCoordinate:placemark.coordinate];
	meetingLocation.streetAddress = placemark.thoroughfare;
	meetingLocation.city = placemark.locality;
	meetingLocation.state = placemark.administrativeArea;
	meetingLocation.zip = placemark.postalCode;
	
	[mapView addAnnotation:meetingLocation];
	[meetingLocation release];
	
	geocoder.delegate = nil;
	[geocoder autorelease];
}



@end
