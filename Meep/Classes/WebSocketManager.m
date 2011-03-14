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

@implementation WebSocketManager

- (id)initWithAccessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        client = [[SocketIoClient alloc] initWithHost:SERVICE_HOST port:SERVICE_PORT resource:@"/websocket/locations/socket/" secure:NO accessToken:accessToken];
        client.delegate = self;
        recentLocations = [[NSMutableArray alloc] initWithCapacity:10];
        recentLocationsCount = 0;
        messageSending = NO;
        [[MeepNotificationCenter sharedNotificationCenter] addObserverForLocationUpdates:self selector:@selector(locationUpdated:)];
    }
    return self;
}

- (void)connect {
    [client connect];
}

- (void)disconnect {
    [client disconnect];
}

- (void)dealloc {
    [self invalidateTimer];
    [[MeepNotificationCenter sharedNotificationCenter] removeObserver:self];
    [recentLocations release];
    [client disconnect];
    client.delegate = nil;
    [client release];
    
    [super dealloc];
}

- (void)locationUpdated:(NSNotification *)notification {
    CLLocation *currentLocation = [[notification userInfo] objectForKey:kLocationUpdateNotification];
    
    UserLocationDTO *userLocation = [[UserLocationDTO alloc] init];
    userLocation.time = [ISO8601DateFormatter stringFromDate:currentLocation.timestamp];
    userLocation.coordinate.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    userLocation.coordinate.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    userLocation.speed = [NSNumber numberWithDouble:currentLocation.speed];
    userLocation.altitude = [NSNumber numberWithDouble:currentLocation.altitude];
    //userLocation.trueHeading = [NSNumber numberWithDouble:currentLocation.];
    userLocation.horizonalAccuracy = [NSNumber numberWithDouble:currentLocation.horizontalAccuracy];
    userLocation.verticalAccuracy = [NSNumber numberWithDouble:currentLocation.verticalAccuracy];
    
    [recentLocations addObject:userLocation];
    recentLocationsCount++;
    
    if (locationUpdateTimer == nil || ![locationUpdateTimer isValid]) {
        [self startTimer];
    }
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

- (void)startTimer {
    [self invalidateTimer];
    locationUpdateTimer = [[NSTimer timerWithTimeInterval:0.5
                                                   target:self 
                                                 selector:@selector(sendLocationUpdates) 
                                                 userInfo:nil 
                                                  repeats:YES] retain];
    
    [[NSRunLoop currentRunLoop] addTimer:locationUpdateTimer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    if (locationUpdateTimer != nil) {
        [locationUpdateTimer invalidate];
    }
}

#pragma mark -
#pragma mark SocketIoClientDelegate

- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON {
    NSLog(@"didReceiveMessage: %@", message);
}

- (void)socketIoClientDidConnect:(SocketIoClient *)client {
    NSLog(@"didConnect");
}
- (void)socketIoClientDidDisconnect:(SocketIoClient *)client {
     NSLog(@"didDisconnect");
    [self invalidateTimer];
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
