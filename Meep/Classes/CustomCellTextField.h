//
//  CustomCellTextField.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellTextField : UITableViewCell {
	
	UITableViewController *tableViewController;
	UITableView *tableView;
	
	IBOutlet UILabel *customTextLabel;
	IBOutlet UITextField *customTextField;
	
	BOOL required;

}

@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UILabel *customTextLabel;
@property (nonatomic, retain) UITextField *customTextField;

@property (nonatomic) BOOL required;

- (BOOL)required;

- (void)setRequired:(BOOL)required;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
