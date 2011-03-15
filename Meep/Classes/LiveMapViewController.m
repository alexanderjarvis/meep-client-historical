//
//  LiveMapViewController.m
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LiveMapViewController.h"

#import "MeepNotificationCenter.h"
#import "MeepAppDelegate.h"
#import "RecentUserLocationsDTO.h"
#import "OtherUserAnnotation.h"
#import "MapView-AnnotationZoom.h"

@interface LiveMapViewController (private)
// LocationService
- (void)headingUpdated:(NSNotification *)notification;
- (void)locationUpdated:(NSNotification *)notification;
// WebSocketManager
- (void)newLocationsFromSocket:(NSNotification *)notification;
@end

@implementation LiveMapViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [[MeepNotificationCenter sharedNotificationCenter] removeObserver:self];
    [currentHeading release];
    [currentLocation release];
    [otherUserAnnotations release];
    [locationService release];
    [mapView release];
    [webSocketManager release];
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
    
    self.title = @"Live Map";
    
    firstLocationUpdate = YES;
    otherUserAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    
    [[MeepNotificationCenter sharedNotificationCenter] addObserverForHeadingUpdates:self selector:@selector(headingUpdated:)];
    [[MeepNotificationCenter sharedNotificationCenter] addObserverForLocationUpdates:self selector:@selector(locationUpdated:)];
    [[MeepNotificationCenter sharedNotificationCenter] addObserverForSocketLocationUpdates:self selector:@selector(newLocationsFromSocket:)];
    
    // WebSocketManager
    ConfigManager *configManager = [[MeepAppDelegate sharedAppDelegate] configManager];
    webSocketManager = [[WebSocketManager alloc] initWithAccessToken:configManager.accessToken];
    [webSocketManager connect];
    
    // Location Service
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
#pragma mark MapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	// If the Current User Annotation
	if ([annotation isKindOfClass:[CurrentUserAnnotation class]]) {
        static NSString *currentUserAnnotationIdentifier = @"Current User Annotation Identifier";
		MKAnnotationView *annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:currentUserAnnotationIdentifier];
		
		if (annotationView == nil) {
			annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation 
                                                          reuseIdentifier:currentUserAnnotationIdentifier];
            annotationView.image = [UIImage imageNamed:@"bluemarble.png"];
		}
        annotationView.annotation = annotation;
		annotationView.enabled = YES;
		annotationView.canShowCallout = YES;
		
		return annotationView;		
	}
    
    // If the Other User Annotation
    if ([annotation isKindOfClass:[OtherUserAnnotation class]]) {
        static NSString *otherUserAnnotationIdentifier = @"Other User Annotation Identifier";
		MKAnnotationView *annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:otherUserAnnotationIdentifier];
		
		if (annotationView == nil) {
			annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation 
                                                          reuseIdentifier:otherUserAnnotationIdentifier];
            annotationView.image = [UIImage imageNamed:@"greenmarble.png"];
		}
        annotationView.annotation = annotation;
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

#pragma mark -
#pragma mark LocationService

- (void)headingUpdated:(NSNotification *)notification {
    currentHeading = [[[notification userInfo] objectForKey:kHeadingUpdateNotification] retain];
}

- (void)locationUpdated:(NSNotification *)notification {
    currentLocation = [[[notification userInfo] objectForKey:kLocationUpdateNotification] retain];
    NSLog(@"latitude: %f", currentLocation.coordinate.latitude);
    NSLog(@"longitude: %f", currentLocation.coordinate.longitude);
    
    CurrentUserAnnotation *currentUserAnnotation = nil;
    
    // If this is the first location update, then create the annotation for the current user.
    if (firstLocationUpdate) {
        firstLocationUpdate = NO;
        currentUserAnnotation = [[CurrentUserAnnotation alloc] init];
        currentUserAnnotation.coordinate = currentLocation.coordinate;
        currentUserAnnotation.title = @"Me";
        [mapView addAnnotation:currentUserAnnotation];
        [currentUserAnnotation release];
        
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 500, 500) animated:YES];
        [mapView selectAnnotation:currentUserAnnotation animated:YES];
        
    } else {
        // Find this users annotation and update its coordinate with an animation.
        for (NSObject<MKAnnotation> *annotation in mapView.annotations) {
            if ([annotation isKindOfClass:[CurrentUserAnnotation class]]) {
                currentUserAnnotation = (CurrentUserAnnotation *)annotation;
                [UIView beginAnimations:@"" context:NULL];
                [UIView setAnimationDuration:.5];
                currentUserAnnotation.coordinate = currentLocation.coordinate;
                [UIView commitAnimations];
                break;
            }
        }
    }
}

#pragma mark -
#pragma mark WebSocketManager

- (void)newLocationsFromSocket:(NSNotification *)notification {
    RecentUserLocationsDTO *recentUserLocationsDTO = [[notification userInfo] objectForKey:kSocketReceivedLocationUpdatesNotification];
    
    OtherUserAnnotation *otherUserAnnotation = nil;
    BOOL newAnnotation = NO;
    
    // If the user already has an annotation then get the object for it.
    for (OtherUserAnnotation *otherUser in otherUserAnnotations) {
        if ([otherUser._id isEqualToNumber:recentUserLocationsDTO._id]) {
            otherUserAnnotation = otherUser;
        }
    }
    
    // If the user does not have an annotation already then create a new annotation.
    if (otherUserAnnotation == nil) {
        newAnnotation = YES;
        otherUserAnnotation = [[[OtherUserAnnotation alloc] init] autorelease];
        otherUserAnnotation._id = recentUserLocationsDTO._id;
        otherUserAnnotation.title = [NSString stringWithFormat:@"%@ %@", recentUserLocationsDTO.firstName, recentUserLocationsDTO.lastName];
        [otherUserAnnotations addObject:otherUserAnnotation];
    }
    
    // Update location history of annotation.
    [otherUserAnnotation.locationHistory addObjectsFromArray:recentUserLocationsDTO.locationHistory];
    
    // Get most recent location
    UserLocationDTO *userLocationDTO = [[recentUserLocationsDTO locationHistory] lastObject];
    CLLocationCoordinate2D currentAnnotationLocation = CLLocationCoordinate2DMake([userLocationDTO.coordinate.latitude doubleValue], 
                                                                                  [userLocationDTO.coordinate.longitude doubleValue]);
    
    // If a new annotation, add it to the map view and change region so that it is shown.
    if (newAnnotation) {
        otherUserAnnotation.coordinate = currentAnnotationLocation;
        [mapView addAnnotation:otherUserAnnotation];
        [mapView zoomToFitAnnotations];
        [mapView selectAnnotation:otherUserAnnotation animated:YES];
        
    } else {
        // Update the annotation's coordinate with an animation.
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:.5];
        otherUserAnnotation.coordinate = currentAnnotationLocation;
        [UIView commitAnimations];
    }
}

@end
