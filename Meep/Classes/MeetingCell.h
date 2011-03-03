//
//  MeetingCell.h
//  Meep
//
//  Created by Alex Jarvis on 03/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeetingCell : UITableViewCell {
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *acceptedAmountLabel;
	IBOutlet UILabel *declinedAmountLabel;

}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *acceptedAmountLabel;
@property (nonatomic, retain) UILabel *declinedAmountLabel;

@end
