//
//  MeepStyleSheet.m
//  Meep
//
//  Created by Alex Jarvis on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeepStyleSheet.h"

@implementation MeepStyleSheet

- (TTStyle*)blackForwardButton:(UIControlState)state {
	TTShape* shape = [TTRoundedRightArrowShape shapeWithRadius:4.5];
	UIColor* tintColor = RGBCOLOR(0, 0, 0);
	return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}
@end