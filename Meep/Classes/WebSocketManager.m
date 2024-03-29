//
//  WebSocketManager.m
//  Meep
//
//  Created by Alex Jarvis on 11/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <YAJL/YAJL.h>

#import "WebSocketManager.h"
#import "ConfigManager.h"
#import "MeepNotificationCenter.h"
#import "UserLocationDTO.h"
#import "DateFormatter.h"
#import "DictionaryModelMapper.h"
#import "RecentUserLocationsDTO.h"
#import "MeepNotificationCenter.h"
#import "Math.h"

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
        client = [[SocketIoClient alloc] initWithHost:SERVICE_HOST port:SERVICE_PORT resource:@"/websocket/locations/socket/" secure:SECURE accessToken:accessToken];
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
    currentHeading = [[notification userInfo] objectForKey:kHeadingUpdateNotification];
}

- (void)locationUpdated:(NSNotification *)notification {
    CLLocation *currentLocation = [[notification userInfo] objectForKey:kLocationUpdateNotification];
    
    UserLocationDTO *userLocation = [[UserLocationDTO alloc] init];
    userLocation.time = [DateFormatter stringFromDate:[NSDate date]]; // sets current time instead of timestamp from CLLocation
    userLocation.coordinate.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    userLocation.coordinate.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    userLocation.speed = [NSNumber numberWithDouble:[Math roundToTwoDecimalPlaces:currentLocation.speed]];
    userLocation.altitude = [NSNumber numberWithDouble:[Math roundToTwoDecimalPlaces:currentLocation.altitude]];
    // Heading may not be available
    if (currentHeading != nil) {
        userLocation.trueHeading = [NSNumber numberWithDouble:[Math roundToTwoDecimalPlaces:currentHeading.trueHeading]];
    }
    userLocation.horizontalAccuracy = [NSNumber numberWithDouble:[Math roundToTwoDecimalPlaces:currentLocation.horizontalAccuracy]];
    userLocation.verticalAccuracy = [NSNumber numberWithDouble:[Math roundToTwoDecimalPlaces:currentLocation.verticalAccuracy]];
    
    [recentLocations addObject:userLocation];
    [userLocation release];
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

- (void)socketIoClient:(SocketIoClient *)client didFailWithError:(NSError *)error {
    //
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
