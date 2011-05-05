//
//  MapView-AnnotationZoom.m
//  Meep
//
//  Created by Alex Jarvis on 14/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "MapView-AnnotationZoom.h"

@implementation MKMapView (AnnotationZoom)

- (void)zoomToFitAnnotations {
    if([self.annotations count] == 0) {
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake(-90, 180);
    CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake(90, -180);
    
    for(NSObject<MKAnnotation> *annotation in self.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [self regionThatFits:region];
    [self setRegion:region animated:YES];
}

@end
