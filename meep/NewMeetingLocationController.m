//
//  NewMeetingLocationController.m
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMeetingLocationController.h"

@implementation NewMeetingLocationController

@synthesize mapView;

- (void)viewDidLoad {
	self.title = @"New Meeting";
	
    [super viewDidLoad];
}

- (IBAction)newPin {
	NSLog(@"New Pin button pressed");
	
	if ([mapView.annotations count] > 0) {
		[mapView removeAnnotations:mapView.annotations];
	}
	
	meetingLocation = [[MapLocation alloc] initWithCoordinate:mapView.centerCoordinate];
	[mapView addAnnotation:meetingLocation];
	[meetingLocation release];
}

- (IBAction)currentLocation {
	NSLog(@"Current Location button pressed");
}

- (IBAction)chooseDate {
	NSLog(@"Choose Date & Time button pressed");
}

- (void)openCallout:(id<MKAnnotation>)annotation {
	[mapView selectAnnotation:annotation animated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
		annotationView.pinColor = MKPinAnnotationColorPurple;
		annotationView.canShowCallout = YES;
		annotationView.draggable = YES;
		[self performSelector:@selector(openCallout:) withObject:annotation afterDelay:0.5];
		
		return annotationView;		
	}
    return nil;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(
																			  @"Error loading map",
																			  @"Error loading map")
													message:[error localizedDescription]
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay")
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}


@end
