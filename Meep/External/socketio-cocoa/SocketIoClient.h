//  Modified (a lot - full of bugs, memory leaks and crashes..) by Alex Jarvis on 11/03/2011.

//
//  SocketIoClient.h
//  SocketIoCocoa
//
//  Created by Fred Potter on 11/11/10.
//  Copyright 2010 Fred Potter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebSocket;
@protocol SocketIoClientDelegate;

@interface SocketIoClient : NSObject {
    WebSocket *_webSocket;
    
    NSTimeInterval _connectTimeout;
    BOOL _tryAgainOnConnectTimeout;
    
    NSTimeInterval _heartbeatTimeout;
    
    NSTimer *_timer;
    
    BOOL _isConnected;
    BOOL _isConnecting;
    
    id<SocketIoClientDelegate> _delegate;
    
    NSMutableArray *_queue;
}

@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, readonly) BOOL isConnecting;

@property (nonatomic, assign) id<SocketIoClientDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval connectTimeout;
@property (nonatomic, assign) BOOL tryAgainOnConnectTimeout;

@property (nonatomic, assign) NSTimeInterval heartbeatTimeout;

- (id)initWithHost:(NSString *)host port:(int)port resource:(NSString *)resource secure:(BOOL)secure accessToken:(NSString *)accessToken;

- (void)connect;
- (void)disconnect;

/**
 * Rather than coupling this with any specific JSON library, you always
 * pass in a string (either _the_ string, or the the JSON-encoded version
 * of your object), and indicate whether or not you're passing a JSON object.
 */
- (void)send:(NSString *)data isJSON:(BOOL)isJSON;

@end

@protocol SocketIoClientDelegate <NSObject>

/**
 * Message is always returned as a string, even when the message was meant to come
 * in as a JSON object.  Decoding the JSON is left as an exercise for the receiver.
 */
- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON;

- (void)socketIoClientDidConnect:(SocketIoClient *)client;

- (void)socketIoClientDidDisconnect:(SocketIoClient *)client;

- (void)socketIoClient:(SocketIoClient *)client didFailWithError:(NSError *)error;

@optional

- (void)socketIoClient:(SocketIoClient *)client didSendMessage:(NSString *)message isJSON:(BOOL)isJSON;

@end