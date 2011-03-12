//
//  WebSocketManager.h
//  Meep
//
//  Created by Alex Jarvis on 11/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SocketIoClient.h"

@interface WebSocketManager : NSObject <SocketIoClientDelegate> {
    
    SocketIoClient *client;
    
}

- (id)initWithAccessToken:(NSString *)accessToken;
- (void)connect;
- (void)disconnect;

@end
