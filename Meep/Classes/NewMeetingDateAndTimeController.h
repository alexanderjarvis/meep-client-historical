//
//  NewMeetingDateAndTimeController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewMeetingDateAndTimeController : UIViewController {
	
	IBOutlet UIDatePicker *datePicker;

}

@property(nonatomic, retain) UIDatePicker *datePicker;

- (IBAction)choosePeople;

@end
