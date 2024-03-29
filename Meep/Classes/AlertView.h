//
//  AlertView.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertView : NSObject <UIAlertViewDelegate> {

}

+ (void)showSimpleAlertMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate;
+ (void)showSimpleAlertMessage:(NSString *)message withTitle:(NSString *)title;
+ (void)showValidationAlert:(NSString *)message;
+ (void)showNetworkAlert:(NSError *)error;
+ (UIAlertView *)showNetworkAlertWithRetry:(NSError *)error delegate:(id)delegate;
+ (UIAlertView *)showNetworkAlertWithForcedRetry:(NSError *)error delegate:(id)delegate;
+ (void)showNoUsersAlert;

@end
