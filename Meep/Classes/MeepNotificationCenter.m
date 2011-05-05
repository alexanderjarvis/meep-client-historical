//
//  MeepNotificationCenter.m
//  Meep
//
//  Created by Alex Jarvis on 12/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "MeepNotificationCenter.h"


@implementation MeepNotificationCenter

static MeepNotificationCenter *sharedNotificationCenter = nil;

- (id)init {
    self = [super init];
    if (self) {
        notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}

+ (MeepNotificationCenter *)sharedNotificationCenter {
    if (sharedNotificationCenter == nil) {
        sharedNotificationCenter = [[super allocWithZone:NULL] init];
    }
    return sharedNotificationCenter;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedNotificationCenter];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (void)release {
    // Do not release
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark Add / Remove Observers

- (void)addObserverForLocationUpdates:(NSObject *)observer selector:(SEL)selector {
    [notificationCenter addObserver:observer selector:selector name:kLocationUpdateNotification object:nil];
}

- (void)addObserverForHeadingUpdates:(NSObject *)observer selector:(SEL)selector {
    [notificationCenter addObserver:observer selector:selector name:kHeadingUpdateNotification object:nil];
}

- (void)addObserverForLocationErrors:(NSObject *)observer selector:(SEL)selector {
    [notificationCenter addObserver:observer selector:selector name:kLocationErrorNotification object:nil];
}

- (void)addObserverForSocketLocationUpdates:(NSObject *)observer selector:(SEL)selector {
    [notificationCenter addObserver:observer selector:selector name:kSocketReceivedLocationUpdatesNotification object:nil];
}

- (void)removeObserver:(NSObject*)observer {
    [notificationCenter removeObserver:observer];
}

@end
