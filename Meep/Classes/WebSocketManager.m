//
//  WebSocketManager.m
//  Meep
//
//  Created by Alex Jarvis on 11/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <YAJL/YAJL.h>

#import "WebSocketManager.h"
#import "ConfigManager.h"
#import "MeepNotificationCenter.h"
#import "UserLocationDTO.h"
#import "ISO8601DateFormatter.h"
#import "DictionaryModelMapper.h"
#import "RecentUserLocationsDTO.h"
#import "MeepNotificationCenter.h"

@interface WebSocketManager (private)
- (void)sendLocationUpdates;
- (void)startTimer;
- (void)invalidateTimer;
// Location Service
- (void)headingUpdated:(NSNotification *)notification;
- (void)locationUpdated:(NSNotification *)notification;
@end

@implementation WebSocketManager

- (id)initWithAccessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        client = [[SocketIoClient alloc] initWithHost:SERVICE_HOST port:SERVICE_PORT resource:@"/websocket/locations/socket/" secure:NO accessToken:accessToken];
        client.delegate = self;
        recentLocations = [[NSMutableArray alloc] initWithCapacity:10];
        recentLocationsCount = 0;
        messageSending = NO;
        [[MeepNotificationCenter sharedNotificationCenter] addObserverForHeadingUpdates:self selector:@selector(headingUpdated:)];
        [[MeepNotificationCenter sharedNotificationCenter] addObserverForLocationUpdates:self selector:@selector(locationUpdated:)];
    }
    return self;
}

- (void)dealloc {
    [[MeepNotificationCenter sharedNotificationCenter] removeObserver:self];
    [self invalidateTimer];
    [recentLocations release];
    [client disconnect];
    client.delegate = nil;
    [client release];
    
    [super dealloc];
}

- (void)connect {
    [client connect];
}

- (void)disconnect {
    [client disconnect];
}

- (void)sendLocationUpdates {
    NSLog(@"send location updates");
    
    if ([client isConnected] && !messageSending && recentLocationsCount > 0) {
        
        [self invalidateTimer];
        messageSending = YES;
        UserLocationDTO *emptyUserLocation = [[UserLocationDTO alloc] init];
        NSArray *arrayOfUserLocationDictionaries = [DictionaryModelMapper createArrayOfDictionariesFromArrayOfObjects:recentLocations 
                                                                                                               ofType:emptyUserLocation];
        [emptyUserLocation release];
        
        NSString *userLocationsString = [arrayOfUserLocationDictionaries yajl_JSONString];
        NSLog(@"userLocations:\n%@", userLocationsString);
                
        [client send:userLocationsString isJSON:YES];
    }
}

/*
 * Waits half a second before sending location updates to group them together.
 */
- (void)startTimer {
    [self invalidateTimer];
    locationUpdateTimer = [[NSTimer timerWithTimeInterval:0.5
                                                   target:self 
                                                 selector:@selector(sendLocationUpdates) 
                                                 userInfo:nil 
                                                  repeats:NO] retain];
    
    [[NSRunLoop currentRunLoop] addTimer:locationUpdateTimer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    if (locationUpdateTimer != nil) {
        [locationUpdateTimer invalidate];
    }
}

#pragma mark -
#pragma mark LocationService

- (void)headingUpdated:(NSNotification *)notification {
    currentHeading = [[[notification userInfo] objectForKey:kHeadingUpdateNotification] retain];
}

- (void)locationUpdated:(NSNotification *)notification {
    CLLocation *currentLocation = [[notification userInfo] objectForKey:kLocationUpdateNotification];
    
    UserLocationDTO *userLocation = [[UserLocationDTO alloc] init];
    userLocation.time = [ISO8601DateFormatter stringFromDate:currentLocation.timestamp];
    userLocation.coordinate.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    userLocation.coordinate.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    userLocation.speed = [NSNumber numberWithDouble:currentLocation.speed];
    userLocation.altitude = [NSNumber numberWithDouble:currentLocation.altitude];
    if (currentHeading != nil) {
        // Round to 2 decimal places.
        double heading = round(currentHeading.trueHeading * 100) / 100;
        userLocation.trueHeading = [NSNumber numberWithDouble:heading];
    }
    userLocation.horizonalAccuracy = [NSNumber numberWithDouble:currentLocation.horizontalAccuracy];
    userLocation.verticalAccuracy = [NSNumber numberWithDouble:currentLocation.verticalAccuracy];
    
    [recentLocations addObject:userLocation];
    recentLocationsCount++;
    
    if (locationUpdateTimer == nil || ![locationUpdateTimer isValid]) {
        [self startTimer];
    }
}

#pragma mark -
#pragma mark SocketIoClientDelegate

- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON {
    NSLog(@"didReceiveMessage: %@", message);
    
    if (isJSON) {
        // Convert Json string to RecentUserLocationsDTO object
        RecentUserLocationsDTO *emptyRecentUserLocationsDTO = [[RecentUserLocationsDTO alloc] init];
		RecentUserLocationsDTO *recentUserLocationsDTO = [DictionaryModelMapper createObject:emptyRecentUserLocationsDTO fromDictionary:[message yajl_JSON]];
		[emptyRecentUserLocationsDTO release];
        
        // Post a notification with the object
        if (recentUserLocationsDTO != nil) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:recentUserLocationsDTO forKey:kSocketReceivedLocationUpdatesNotification];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSocketReceivedLocationUpdatesNotification object:self userInfo:dictionary];
        }
    }
}

- (void)socketIoClientDidConnect:(SocketIoClient *)client {
    NSLog(@"didConnect");
    [self sendLocationUpdates];
}
- (void)socketIoClientDidDisconnect:(SocketIoClient *)client {
     NSLog(@"didDisconnect");
}

// optional

- (void)socketIoClient:(SocketIoClient *)client didSendMessage:(NSString *)message isJSON:(BOOL)isJSON {
    NSLog(@"didSendMessage: %@", message);
    
    if (isJSON) {
        [recentLocations removeAllObjects];
        recentLocationsCount = 0;
        messageSending = NO;
    }
}


@end
