//
//  NewMeetingDateAndTimeController.h
//  meep
//
//  Created by Alex Jarvis on 31/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

#import "CustomCellTextField.h"

@interface NewMeetingDateAndTimeController : UITableViewController <UITextFieldDelegate, TTPostControllerDelegate> {
	
	NSDateFormatter *dateFormatter;
	
	IBOutlet UIButton *choosePeopleButton;
	UIDatePicker *datePicker;
	CustomCellTextField *dateCell;
	CustomCellTextField *titleCell;
	CustomCellTextField *descriptionCell;
}

@property(nonatomic, retain) UIButton *choosePeopleButton;
@property(nonatomic, retain) UIDatePicker *datePicker;
@property(nonatomic, retain) CustomCellTextField *dateCell;
@property(nonatomic, retain) CustomCellTextField *titleCell;
@property(nonatomic, retain) CustomCellTextField *descriptionCell;

- (void)choosePeopleButtonPressed;

- (void)datePickerUpdated;

- (TTPostController *)showPostController;

@end
