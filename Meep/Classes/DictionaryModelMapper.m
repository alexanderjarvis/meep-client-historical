//
//  DictionaryModelMapper.m
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DictionaryModelMapper.h"

#import <objc/runtime.h>

@implementation DictionaryModelMapper

+ (void)createObject:(NSObject *)object fromDictionary:(NSDictionary *)dictionary {
	
	dictionary = [self manipulateDictionaryKeysForLanguageKeywords:dictionary];
	
	// Get the properties of the object from the Objective C runtime
	NSArray *properties = [self propertiesFromObject:object];
	
	NSLog(@"properties: %@", properties);
	
	// For all of the properties that the object holds, set the values from the dictionary
	for (int i = 0; i < [properties count]; i++) {
		NSString *key = [properties objectAtIndex:i];
		NSString *value = [dictionary valueForKey:key];
		if (value != nil) {
			NSLog(@"setValue: %@ forKey: %@", value, key);
			[object setValue:value forKey:key];
		}
	}
}

+ (NSArray *)propertiesFromObject:(NSObject *)object {
	Class clazz = [object class];
    u_int count;
	
    objc_property_t * properties = class_copyPropertyList(clazz, &count);
    NSMutableArray * propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
	
	return [NSArray arrayWithArray: propertyArray];
}

/*
 * There are certain words in the language that cannot be used as attribute names,
 * e.g. id
 *
 * When a dictionary is intended to be mapped to an object, the object can accomodate for
 * the reserved language words by prefixing an underscore '_' to the attribute name.
 *
 * This method adds underscores '_' to the dictionary keys that are reserved words in the language.
 *
 * So for example a key of 'id' in the dictionary is changed to '_id'.
 *
 * TODO: expand this method to other reserved words apart from just 'id' if required.
 */
+ (NSDictionary *)manipulateDictionaryKeysForLanguageKeywords:(NSDictionary *)dictionary {
	
	// Check if the Dictionary contains the reserved word, if not, return the existing dictionary
	id object = [dictionary objectForKey:@"id"];
	if (object == nil) {
		return dictionary;
	}
	
	// Create a Dictionary from the existing one and replace the keys
	NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
	[mutableDictionary setDictionary: dictionary];
	
	[mutableDictionary removeObjectForKey:@"id"];
	[mutableDictionary setObject:object forKey:@"_id"];
	
	NSDictionary *newDictionary = [NSDictionary dictionaryWithDictionary:mutableDictionary];
	[mutableDictionary release];
	
	return newDictionary;
}

@end
