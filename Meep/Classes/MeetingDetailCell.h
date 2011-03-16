//
//  MeetingDetailCell.h
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeetingDetailCellDelegate.h"

#define MeetingDetailCellHeightNormal 160
#define MeetingDetailCellHeightExpanded 220

@interface MeetingDetailCell : UITableViewCell {
    
    id <MeetingDetailCellDelegate> delegate;

    IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *acceptedAmountLabel;
	IBOutlet UILabel *declinedAmountLabel;
    IBOutlet UILabel *awaitingReplyAmountLabel;
    IBOutlet UISegmentedControl *attendingControl;
    IBOutlet UILabel *alertMeLabel;
    IBOutlet UISlider *alertMeSlider;
    
    NSUInteger alertMeMinutes;
    
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *acceptedAmountLabel;
@property (nonatomic, retain) UILabel *declinedAmountLabel;
@property (nonatomic, retain) UILabel *awaitingReplyAmountLabel;
@property (nonatomic, retain) UISegmentedControl *attendingControl;
@property (nonatomic, retain) UILabel *alertMeLabel;
@property (nonatomic, retain) UISlider *alertMeSlider;

- (IBAction)attendingControlAction;

- (IBAction)alertMeSliderValueChanged;

- (IBAction)alertMeSliderDidEndEditing;

- (void)showAlertMeControl;

- (void)hideAlertMeControl;

@end
