//
//  CLViewController.h
//  meep
//
//  Created by Alex Jarvis on 17/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface CLViewController : UIViewController <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	NSMutableArray *locationMeasurements;
	CLLocation *bestEffortAtLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

@end

