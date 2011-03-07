//
//  TTFixedWidthButton.h
//  Meep
//
//  A slightly modified TTButton that allows the width to the fixed instead of being
//  calculated automatically. Could not easily extend TTButton although this would
//  have been preferable.
//
//  Created by Alex Jarvis on 07/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// Style
#import "Three20Style/TTStyleDelegate.h"

@protocol TTImageViewDelegate;

@interface TTFixedWidthButton : UIControl <TTStyleDelegate> {
    NSMutableDictionary*  _content;
    UIFont*               _font;
    BOOL                  _isVertical;
    
    id<TTImageViewDelegate> _imageDelegate;
    
    CGFloat _width;
}

@property (nonatomic, retain) UIFont* font;
@property (nonatomic)         BOOL    isVertical;
@property (nonatomic) CGFloat width;

// This must be set before you call setImage:
@property (nonatomic, assign) id<TTImageViewDelegate> imageDelegate;

+ (TTFixedWidthButton*)buttonWithStyle:(NSString*)selector;
+ (TTFixedWidthButton*)buttonWithStyle:(NSString*)selector title:(NSString*)title;

- (NSString*)titleForState:(UIControlState)state;
- (void)setTitle:(NSString*)title forState:(UIControlState)state;

- (NSString*)imageForState:(UIControlState)state;
- (void)setImage:(NSString*)title forState:(UIControlState)state;

- (TTStyle*)styleForState:(UIControlState)state;
- (void)setStyle:(TTStyle*)style forState:(UIControlState)state;

/**
 * Sets the styles for all control states using a single style selector.
 *
 * The method for the selector must accept a single argument for the control state.  It will
 * be called to return a style for each of the different control states.
 */
- (void)setStylesWithSelector:(NSString*)selector;

- (void)suspendLoadingImages:(BOOL)suspended;

- (CGRect)rectForImage;

@end
