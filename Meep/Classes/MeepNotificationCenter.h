//
//  MeepNotificationCenter.h
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLocationUpdateNotification @"LocationUpdateNotification"
#define kHeadingUpdateNotification @"HeadingUpdateNotification"
#define kLocationErrorNotification @"LocationErrorNotification"

#define kSocketReceivedLocationUpdatesNotification @"kSocketReceivedLocationUpdatesNotification"

@interface MeepNotificationCenter : NSObject {
    
    NSNotificationCenter *notificationCenter;
    
}

+ (MeepNotificationCenter *)sharedNotificationCenter;

- (void)addObserverForLocationUpdates:(NSObject *)observer selector:(SEL)selector;

- (void)addObserverForHeadingUpdates:(NSObject *)observer selector:(SEL)selector;

- (void)addObserverForLocationErrors:(NSObject *)observer selector:(SEL)selector;


- (void)addObserverForSocketLocationUpdates:(NSObject *)observer selector:(SEL)selector;

- (void)removeObserver:(NSObject*)observer;

@end
