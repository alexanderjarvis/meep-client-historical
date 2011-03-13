//
//  ConfigManager.m
//  meep
//
//  Created by Alex Jarvis on 22/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager

@synthesize appConfigDictionary;
@synthesize serviceUrl;
@synthesize email;
@synthesize accessToken;

/*
 *
 */
- (BOOL)configFileExists {
    
	NSString *filePath = [self dataFilePath:kConfigFileName];
	
	// If file exists
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		return YES;
	}
	return NO;
}

/*
 *
 */
- (void)saveConfig {
    
	NSLog(@"Saving Config");
	
	NSArray *keys = [NSArray arrayWithObjects:kEmailKey, kAccessTokenKey, nil];
	NSArray *values = [NSArray arrayWithObjects:self.email, self.accessToken, nil];
	self.appConfigDictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	
	[appConfigDictionary writeToFile:[self dataFilePath:kConfigFileName] atomically:YES];
	
	NSLog(@"Wrote app config to file: %@", appConfigDictionary);
}

/*
 *
 */
- (NSDictionary *)loadConfig {
    
	NSLog(@"Loading Config");
    
    NSString *servicePort = nil;
    if (SERVICE_PORT == 80 || SERVICE_PORT == 443) {
        servicePort = @"";
    } else { 
        servicePort = [NSString stringWithFormat:@":%d", SERVICE_PORT];
    }
    
    self.serviceUrl = [NSString stringWithFormat:@"%@%@%@/", SERVICE_SCHEME, SERVICE_HOST, servicePort];
	
	if ([self configFileExists]) {
		NSString *filePath = [self dataFilePath: kConfigFileName];
		
		self.appConfigDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
		
		if (appConfigDictionary != nil) {
			self.email = [appConfigDictionary valueForKey:kEmailKey];
			self.accessToken = [appConfigDictionary valueForKey:kAccessTokenKey];
		}
		
		return appConfigDictionary;
		
	} else {
		self.email = @"";
		self.accessToken = @"";
		[self saveConfig];
	}
	
	return nil;
}

/*
 * Determines and returns the file path in the documents directory.
 */
- (NSString *)dataFilePath:(NSString *)fileName {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)dealloc {
	[appConfigDictionary release];
	[serviceUrl release];
	[email release];
	[accessToken release];
	[super dealloc];
}

@end
