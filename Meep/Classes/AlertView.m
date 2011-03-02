//
//  AlertView.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+ (void)showValidationAlert:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Oops!" 
						  message:message
						  delegate:self 
						  cancelButtonTitle:@"Okay" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)showNetworkAlert:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Network Error" 
						  message:[error localizedDescription]
						  delegate:self
						  cancelButtonTitle:@"Dismiss" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)showNoUsersAlert {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"No Friends!" 
						  message:@"You must add some friends before you can create a meeting."
						  delegate:self 
						  cancelButtonTitle:@"Okay" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
