//
//  MeepNotificationCenter.h
//  Meep
//  
//  Although this class was created by me, it was inspired by the work in the
//  nARLib library by Naja von Schumde (ARNotificationCenter).
//
//  The license and library are included in this distribution and instead
//  of using its notifcation center I wanted to create my own so that it could be
//  used for the entire application instead and not just for location updates.
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
