//
//  ConfigManager.h
//  meep
//
//  Created by Alex Jarvis on 22/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConfigFileName @"config.plist"

#define kEmailKey @"email"
#define kAccessTokenKey @"access_token"

@interface ConfigManager : NSObject {
	
	NSDictionary *appConfigDictionary;
	NSString *email;
	NSString *access_token;
	
}

@property (nonatomic, retain) NSDictionary *appConfigDictionary;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *access_token;

- (BOOL)configFileExists;
- (void)saveConfig;
- (NSDictionary *)loadConfig;
- (NSString *)dataFilePath:(NSString *)fileName;

@end
