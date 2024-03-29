//
//  WebSocketManager.h
//  Meep
//
//  Created by Alex Jarvis on 11/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SocketIoClient.h"

@interface WebSocketManager : NSObject <SocketIoClientDelegate> {
    
    SocketIoClient *client;
    
    NSMutableArray *recentLocations;
    NSUInteger recentLocationsCount;
    NSTimer *locationUpdateTimer;
    BOOL messageSending;
    
    CLHeading *currentHeading;
}

- (id)initWithAccessToken:(NSString *)accessToken;
- (void)connect;
- (void)disconnect;

@end
