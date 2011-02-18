//
//  UserRequestsCustomCell.h
//  Meep
//
//  Created by Alex Jarvis on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserRequestsCustomCell : UITableViewCell {
	
	IBOutlet UILabel *customLabel;

}

@property (nonatomic, retain) UILabel *customLabel;

@end
