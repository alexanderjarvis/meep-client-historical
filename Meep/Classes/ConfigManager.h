//
//  ConfigManager.h
//  meep
//
//  Created by Alex Jarvis on 22/01/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConfigFileName @"config.plist"

#define kEmailKey @"email"
#define kAccessTokenKey @"access_token"

// The host for the web service
#define SERVICE_HOST @"meep.it"
#define SERVICE_PORT 443
#define SECURE 1
#define SERVICE_SCHEME @"https://"
//#define SERVICE_HOST @"localhost"
//#define SERVICE_PORT 9000
//#define SECURE 0
//#define SERVICE_SCHEME @"http://"

@interface ConfigManager : NSObject {
	
	NSDictionary *appConfigDictionary;
    
	NSString *serviceUrl;
    
	NSString *email;
	NSString *accessToken;
	
}

@property (nonatomic, retain) NSDictionary *appConfigDictionary;
@property (nonatomic, copy) NSString *serviceUrl;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *accessToken;

- (BOOL)configFileExists;
- (void)saveConfig;
- (NSDictionary *)loadConfig;
- (NSString *)dataFilePath:(NSString *)fileName;

@end
