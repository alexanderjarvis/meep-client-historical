//
//  MeetingDetailCell.m
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingDetailCell.h"


@implementation MeetingDetailCell

@synthesize delegate;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize acceptedAmountLabel;
@synthesize declinedAmountLabel;
@synthesize awaitingReplyAmountLabel;
@synthesize attendingControl;
@synthesize alertMeLabel;
@synthesize alertMeSlider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialisation code
        alertMeSlider.enabled = NO;
        alertMeSlider.hidden = YES;
        alertMeLabel.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // Override default behaviour
    //[super setSelected:selected animated:animated];
    
}

/*
 * Called whenever the value for the segmented control is changed.
 */
- (IBAction)attendingControlAction {

    NSInteger selectedIndex = attendingControl.selectedSegmentIndex;
    
    switch (selectedIndex) {
        case -1:
            // Not selected
            break;
        case 0:
            // Attending
            [delegate attendingButtonPressed];
            [self showAlertMeSlider];
            break;
        case 1:
            // Not attending
            [delegate notAttendingButtonPressed];
            [self hideAlertMeSlider];
            break;
            
    }
}

- (IBAction)alertMeSliderValueChanged {
    NSUInteger minValue = 1;
    NSUInteger maxValue = 30;
    
    float sliderValue = [alertMeSlider value];
    
    if (sliderValue == 0) {
        alertMeMinutes = minValue;
    } else {
        alertMeMinutes = (NSUInteger)ceilf(sliderValue * maxValue);
    }
    
    NSString *prefix = @"Alert me";
    NSString *suffixSingular = @"minute before";
    NSString *suffixPlural = @"minutes before";
    
    NSString *suffix;
    
    if (alertMeMinutes == 1) {
        suffix = suffixSingular;
    } else {
        suffix = suffixPlural;
    }
    
    alertMeLabel.text = [NSString stringWithFormat:@"%@ %i %@", prefix, alertMeMinutes, suffix];
    
}

- (IBAction)alertMeSliderTouchDown {
    alertMeLabelPreviousValue = [alertMeLabel.text copy];
    alertMeSliderPreviousValue = [alertMeSlider value];
}

- (IBAction)alertMeSliderTouchUpInside {
    [delegate alertMeSliderDidEndEditing:[NSNumber numberWithUnsignedInt:alertMeMinutes]];
}

- (void)showAlertMeSlider {
    alertMeSlider.enabled = YES;
    alertMeSlider.hidden = NO;
    alertMeLabel.hidden = NO;
}

- (void)hideAlertMeSlider {
    alertMeSlider.enabled = NO;
    alertMeSlider.hidden = YES;
    alertMeLabel.hidden = YES;
}

- (void)rollbackAlertMeSlider {
    alertMeLabel.text = alertMeLabelPreviousValue;
    [alertMeSlider setValue:alertMeSliderPreviousValue animated:YES];
}

- (void)dealloc {
    [titleLabel release];
	[dateLabel release];
	[timeLabel release];
	[acceptedAmountLabel release];
	[declinedAmountLabel release];
    [awaitingReplyAmountLabel release];
    [attendingControl release];
    [alertMeLabel release];
    [alertMeSlider release];
    [super dealloc];
}


@end
