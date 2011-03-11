//
//  WebSocketManager.m
//  Meep
//
//  Created by Alex Jarvis on 11/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebSocketManager.h"

@implementation WebSocketManager

- (void)example {
    
    NSLog(@"WebSocketManager");
    
    SocketIoClient *client = [[SocketIoClient alloc] initWithHost:@"ws://websocket/locations/socket/" port:9000];
    client.delegate = self;
    
    [client connect];
    
    
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark SocketIoClientDelegate

- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON {
    NSLog(@"didReceiveMessage: %@", message);
}

- (void)socketIoClientDidConnect:(SocketIoClient *)client {
    NSLog(@"didConnect");
    [client send:@"Hello Socket.IO" isJSON:NO];
    
}
- (void)socketIoClientDidDisconnect:(SocketIoClient *)client {
     NSLog(@"didDisconnect");
}

// optional

- (void)socketIoClient:(SocketIoClient *)client didSendMessage:(NSString *)message isJSON:(BOOL)isJSON {
     NSLog(@"didSendMessage: %@", message);
}


@end
