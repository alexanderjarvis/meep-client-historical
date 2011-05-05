//
//  DeclineMeetingRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 05/03/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import "MeetingDTO.h"

@class DeclineMeetingRequestManager;

@protocol DeclineMeetingRequestManagerDelegate <NSObject>

@required

- (void)declineMeetingSuccessful;

- (void)declineMeetingFailedWithError:(NSError *)error;

- (void)declineMeetingFailedWithNetworkError:(NSError *)error;

@end