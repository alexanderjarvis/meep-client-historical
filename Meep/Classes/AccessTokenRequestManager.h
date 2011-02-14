//
//  AccessTokenRequestManager.h
//  Meep
//
//  Created by Alex Jarvis on 14/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccessTokenRequestManager : NSObject {

	NSString *accessToken;

}

@property (nonatomic, copy) NSString *accessToken;

- (id)initWithAccessToken:(NSString *)token;

@end