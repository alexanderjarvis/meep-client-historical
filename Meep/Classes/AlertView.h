//
//  AlertView.h
//  Meep
//
//  Created by Alex Jarvis on 19/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlertView : NSObject {

}

+ (void)showSimpleAlertMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate;
+ (void)showSimpleAlertMessage:(NSString *)message withTitle:(NSString *)title;
+ (void)showValidationAlert:(NSString *)message;
+ (void)showNetworkAlert:(NSError *)error; 
+ (void)showNoUsersAlert;

@end
