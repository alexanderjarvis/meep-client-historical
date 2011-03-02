//
//  AlertView.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+ (void)showSimpleAlertMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:title 
						  message:message
						  delegate:delegate 
						  cancelButtonTitle:@"Okay" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)showSimpleAlertMessage:(NSString *)message withTitle:(NSString *)title {
	[self showSimpleAlertMessage:message withTitle:title andDelegate:nil];
}

+ (void)showValidationAlert:(NSString *)message {
	[self showSimpleAlertMessage:message withTitle:@"Oops!"];
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
	[self showSimpleAlertMessage:@"You must add some friends before you can create a meeting." withTitle:@"No Friends!"];
}

@end
