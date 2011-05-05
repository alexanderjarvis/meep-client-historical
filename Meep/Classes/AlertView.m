//
//  AlertView.m
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
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
						  delegate:nil
						  cancelButtonTitle:@"Dismiss" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (UIAlertView *)showNetworkAlertWithRetry:(NSError *)error delegate:(id)delegate {
	UIAlertView *alert = [[[UIAlertView alloc]
						  initWithTitle:@"Network Error" 
						  message:[error localizedDescription]
						  delegate:delegate
						  cancelButtonTitle:@"Dismiss" 
						  otherButtonTitles:@"Retry", nil] autorelease];
	[alert show];
	return alert;
}

+ (UIAlertView *)showNetworkAlertWithForcedRetry:(NSError *)error delegate:(id)delegate {
    UIAlertView *alert = [[[UIAlertView alloc]
                           initWithTitle:@"Network Error" 
                           message:[error localizedDescription]
                           delegate:delegate
                           cancelButtonTitle:@"Retry" 
                           otherButtonTitles:nil] autorelease];
	[alert show];
	return alert;
}

+ (void)showNoUsersAlert {
	[self showSimpleAlertMessage:@"You must add some friends before you can create a meeting." withTitle:@"No Friends!"];
}

@end
