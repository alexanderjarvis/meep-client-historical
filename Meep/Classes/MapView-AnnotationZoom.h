//
//  MapView-AnnotationZoom.h
//  Meep
//
//  Created by Alex Jarvis on 14/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (AnnotationZoom)
    
- (void)zoomToFitAnnotations;

@end