//
//  CustomCellTextField.h
//  Minutes
//
//  Created by Alex Jarvis on 10/01/2010.
//  Copyright 2010 AppSoup. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellTextField : UITableViewCell {
	
	IBOutlet UILabel *customTextLabel;
	IBOutlet UITextField *customTextField;

}

@property (nonatomic, retain) UILabel *customTextLabel;
@property (nonatomic, retain) UITextField *customTextField;

@end
