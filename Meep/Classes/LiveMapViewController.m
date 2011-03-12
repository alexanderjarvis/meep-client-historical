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
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [locationService release];
    [mapView release];
    [backButton release];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark

- (void)locationUpdated:(NSNotification *)notification {
    CLLocation *currentLocation = [[notification userInfo] objectForKey:kLocationUpdateNotification];
    NSLog(@"latitude: %f", currentLocation.coordinate.latitude);
    NSLog(@"longitude: %f", currentLocation.coordinate.longitude);
    
    
    [mapView setRegion:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 500, 500) animated:YES];
    
    
}

@end
