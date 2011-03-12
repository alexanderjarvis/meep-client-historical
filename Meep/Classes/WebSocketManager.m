//
//  WebSocketManager.m
//  Meep
//
//  Created by Alex Jarvis on 11/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebSocketManager.h"

@implementation WebSocketManager

- (id)initWithAccessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        client = [[SocketIoClient alloc] initWithHost:@"localhost" port:9000 resource:@"/websocket/locations/socket/" secure:NO accessToken:accessToken];
        client.delegate = self;
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
    [client disconnect];
    [client release];
    [super dealloc];
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
}

// optional

- (void)socketIoClient:(SocketIoClient *)client didSendMessage:(NSString *)message isJSON:(BOOL)isJSON {
     NSLog(@"didSendMessage: %@", message);
}


@end
