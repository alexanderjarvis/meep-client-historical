//  Modified (a lot - full of bugs, memory leaks and crashes..) by Alex Jarvis on 11/03/2011.

//
//  SocketIoClient.m
//  SocketIoCocoa
//
//  Created by Fred Potter on 11/11/10.
//  Copyright 2010 Fred Potter. All rights reserved.
//

#import "SocketIoClient.h"
#import "WebSocket.h"

@interface SocketIoClient (FP_Private) <WebSocketDelegate>
- (void)checkIfConnected;
- (void)log:(NSString *)message;
- (NSString *)encode:(NSArray *)messages;
- (NSArray *)decode:(NSString *)data;
- (void)notifyMessagesSent:(NSArray *)messages;
- (void)onTimeout;
- (void)setTimer;
- (void)invalidateTimer;
- (void)onHeartbeat:(NSString *)heartbeat;
- (void)doQueue;
- (void)onConnect;
- (void)onDisconnect;
- (void)onMessage:(NSString *)message;
- (void)onData:(NSString *)data;
@end

@implementation SocketIoClient

@synthesize delegate = _delegate;
@synthesize connectTimeout = _connectTimeout;
@synthesize tryAgainOnConnectTimeout = _tryAgainOnConnectTimeout;
@synthesize heartbeatTimeout = _heartbeatTimeout;
@synthesize isConnecting = _isConnecting;
@synthesize isConnected = _isConnected;

- (id)initWithHost:(NSString *)host port:(int)port resource:(NSString *)resource secure:(BOOL)secure accessToken:(NSString *)accessToken; {
    self = [super init];
    if (self) {
        _queue = [[NSMutableArray array] retain];
        _connectTimeout = 5.0;
        _tryAgainOnConnectTimeout = YES;
        _heartbeatTimeout = 15.0;
        
        NSString *scheme = @"ws://";
        if (secure) {
            scheme = @"wss://";
        }
        
        NSString *URL = [NSString stringWithFormat:@"%@%@:%d%@?oauth_token=%@", scheme, host, port, resource, accessToken];
        _webSocket = [[WebSocket alloc] initWithURLString:URL delegate:self];
    }
    return self;
}

- (void)dealloc {
    [_timer release];
    _timer = nil;
    _webSocket.delegate = nil;
    [_webSocket release];
    [_queue release];
    
    [super dealloc];
}

- (void)checkIfConnected {
    if (!_isConnected) {        
        if (_tryAgainOnConnectTimeout) {
            [self connect];
        }
    }
}

- (void)connect {
    if (!_isConnected && !_isConnecting) {
        
        _isConnecting = YES;

        [self log:[NSString stringWithFormat:@"Opening %@", _webSocket.url]];
                
        [_webSocket open];
        
        if (_connectTimeout > 0.0) {
            [self performSelector:@selector(checkIfConnected) withObject:nil afterDelay:_connectTimeout];
        }
    }
}

- (void)disconnect {
    [self log:@"disconnect"];
    [self invalidateTimer];
    [_webSocket close];
}

- (void)send:(NSString *)data isJSON:(BOOL)isJSON {
    [self log:[NSString stringWithFormat:@"Sending %@:\n%@", isJSON ? @"JSON" : @"TEXT", data]];
    
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:
                             data,
                             @"data",
                             isJSON ? @"json" : @"text",
                             @"type",
                             nil];
    
    if (!_isConnected) {
        [_queue addObject:message];
    } else {
        NSArray *messages = [NSArray arrayWithObject:message];
        
        [_webSocket send:[self encode:messages]];
        
        [self notifyMessagesSent:messages];
    }
}

#pragma mark SocketIO Related Protocol

- (void)notifyMessagesSent:(NSArray *)messages {
    if ([_delegate respondsToSelector:@selector(socketIoClient:didSendMessage:isJSON:)]) {
        for (NSDictionary *message in messages) {
            NSString *data = [message objectForKey:@"data"];
            NSString *type = [message objectForKey:@"type"];
            
            [_delegate socketIoClient:self didSendMessage:data isJSON:[type isEqualToString:@"json"]];
        }
    }
}

- (NSString *)encode:(NSArray *)messages {
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    for (NSDictionary *message in messages) {
        
        NSString *data = [message objectForKey:@"data"];
        NSString *type = [message objectForKey:@"type"];
        
        NSString *dataWithType = nil;
        
        if ([type isEqualToString:@"json"]) {
            dataWithType = [NSString stringWithFormat:@"~j~%@", data];
        } else {
            dataWithType = data;
        }
        
        [buffer appendString:@"~m~"];
        [buffer appendFormat:@"%d", [dataWithType length]];
        [buffer appendString:@"~m~"];
        [buffer appendString:dataWithType];
    }
    
    return buffer;
}

- (NSArray *)decode:(NSString *)data {
    NSMutableArray *messages = [NSMutableArray array];
    
    int i = 0;
    int len = [data length];
    while (i < len) {
        if ([[data substringWithRange:NSMakeRange(i, 3)] isEqualToString:@"~m~"]) {
            
            i += 3;
            
            int lengthOfLengthString = 0;
            
            for (int j = i; j < len; j++) {
                unichar c = [data characterAtIndex:j];
                
                if ('0' <= c && c <= '9') {
                    lengthOfLengthString++;
                } else {
                    break;
                }
            }
            
            int messageLength = [[data substringWithRange:NSMakeRange(i, lengthOfLengthString)] intValue];
            i += lengthOfLengthString;
            
            // skip past the next frame
            i += 3;
            
            NSString *message = [data substringWithRange:NSMakeRange(i, messageLength)];
            i += messageLength;
            
            [messages addObject:message];
            
        } else {
            // No frame marker
            break;
        }
    }
    
    return messages;
}

- (void)onTimeout {
    [self log:@"Timed out waiting for heartbeat."];
    [self connect];
}

- (void)setTimeout {  
    [self invalidateTimer];
    
    _timer = [[NSTimer timerWithTimeInterval:_heartbeatTimeout
                                        target:self 
                                      selector:@selector(onTimeout) 
                                      userInfo:nil 
                                       repeats:NO] retain];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    if (_timer != nil) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
}

- (void)onHeartbeat:(NSString *)heartbeat {
    [self send:@"~h~PONG" isJSON:NO];
}

- (void)doQueue {
    if ([_queue count] > 0) {
        [_webSocket send:[self encode:_queue]];
        
        [self notifyMessagesSent:_queue];
        
        [_queue removeAllObjects];
    }
}

- (void)onConnect {
    _isConnected = YES;
    _isConnecting = NO;
    
    [self doQueue];
    
    if (_delegate != nil) {
        [_delegate socketIoClientDidConnect:self];
    }
    
    [self setTimeout];
}

- (void)onDisconnect {
    BOOL wasConnected = _isConnected;
    
    _isConnected = NO;
    _isConnecting = NO;
    
    [_queue removeAllObjects];
    
    if (wasConnected && _delegate != nil) {
        [_delegate socketIoClientDidDisconnect:self];
    }
}

- (void)onFail {
    _isConnecting = NO;
    [self connect];
}

- (void)onMessage:(NSString *)message {
    [self log:[NSString stringWithFormat:@"Message: %@", message]];
    
    if ([[message substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"~h~"]) {
        [self onHeartbeat:[message substringFromIndex:3]];
    } else if ([[message substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"~j~"]) {
        if (_delegate != nil) {
            [_delegate socketIoClient:self didReceiveMessage:[message substringFromIndex:3] isJSON:YES];
        }
    } else {
        if (_delegate != nil) {
            [_delegate socketIoClient:self didReceiveMessage:message isJSON:NO];
        }
    }
}

- (void)onData:(NSString *)data {
    [self setTimeout];
    
    [self log:[NSString stringWithFormat:@"Data received: %@", data]];
    
    NSArray *messages = [self decode:data];
    
    for (NSString *message in messages) {
        [self onMessage:message];
    }
}

#pragma mark WebSocket Delegate Methods

- (void)webSocket:(WebSocket *)ws didFailWithError:(NSError *)error {
    [self log:[NSString stringWithFormat:@"Connection failed with error: %@", [error localizedDescription]]];
    [self onFail];
    //TODO: show error to user
}

- (void)webSocketDidClose:(WebSocket*)webSocket {
    [self log:[NSString stringWithFormat:@"Connection closed."]];
    [self onDisconnect];
}

- (void)webSocketDidOpen:(WebSocket *)ws {
    [self log:[NSString stringWithFormat:@"Connection opened."]];
    [self onConnect];
}

- (void)webSocket:(WebSocket *)ws didReceiveMessage:(NSString*)message {  
    [self log:[NSString stringWithFormat:@"Received %@", message]];
    [self onData:message];
}

- (void)log:(NSString *)message {
    NSLog(@"%@", message);
}

@end
