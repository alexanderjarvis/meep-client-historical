//
//  HTTPDemoViewController.h
//  meep
//
//  Created by Alex Jarvis on 12/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HTTPDemoViewController : UIViewController {
	UILabel *label;
	
	NSDate *methodStart;
}

@property(nonatomic, retain) IBOutlet UILabel *label;

@property(nonatomic, retain) NSDate *methodStart;

- (IBAction)loginRequest;

@end
