//
//  DeclineMeetingRequestManagerDelegate.h
//  Meep
//
//  Created by Alex Jarvis on 05/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingDTO.h"

@class DeclineMeetingRequestManager;

@protocol DeclineMeetingRequestManagerDelegate <NSObject>

@required

- (void)declineMeetingSuccessful:(MeetingDTO *)meeting;

- (void)declineMeetingFailedWithError:(NSError *)error;

- (void)declineMeetingFailedWithNetworkError:(NSError *)error;

@end