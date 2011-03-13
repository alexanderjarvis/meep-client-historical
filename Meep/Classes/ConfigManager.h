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

// The host for the web service
#define DEBUG 0
#ifdef DEBUG
#define SERVICE_HOST @"169.254.100.172"
#define SERVICE_PORT 9000
#endif
#ifndef DEBUG
#define SECURE 1
#define SERVICE_HOST @"meep.it"
#define SERVICE_PORT 443
#endif
// The schemes, independent of debug status
#ifdef SECURE
#define SERVICE_SCHEME @"https://"
#endif
#ifndef SECURE
#define SERVICE_SCHEME @"http://"
#endif

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
