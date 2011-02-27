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

/*
 *
 */
+ (id)createObject:(NSObject *)object fromDictionary:(NSDictionary *)dictionary {
	
	dictionary = [self manipulateDictionaryKeysWhenToObject:dictionary];
	
	id resultObject = [[[object class] allocWithZone:nil] init];
	
	// Get the properties of the object from the Objective C runtime
	NSArray *properties = [self propertiesFromObject:resultObject];
	
	// For all of the properties that the object holds, set the values from the dictionary
	for (int i = 0; i < [properties count]; i++) {
		NSString *key = [properties objectAtIndex:i];
		NSObject *value = [dictionary objectForKey:key];
		if (value != nil) {
			if ([resultObject respondsToSelector:NSSelectorFromString(key)]) {
				
				// Determine if the object is an Array of other objects
				id objectType = [resultObject valueForKey:key];
				if ([objectType isKindOfClass:[NSArray class]]) {
					// get type from matching _type_ property
					NSString *typeString = [NSString stringWithFormat:@"_type_%@", key];
					objectType = [resultObject valueForKey:typeString];
					NSArray *arrayOfObjects = [self createArrayOfObjects:objectType fromArrayOfDictionaries:(NSArray *)value];
					[resultObject setValue:arrayOfObjects forKey:key];
				} else {
					// If not an array, then set the value of the property
					[resultObject setValue:value forKey:key];
				}
				
			}
		}
	}
	
	return resultObject;
}

/*
 *
 */
+ (NSArray *)createArrayOfObjects:(NSObject *)object fromArrayOfDictionaries:(NSArray *)dictionaries {

	NSMutableArray *arrayOfObjects = [NSMutableArray arrayWithCapacity:[dictionaries count]];
	
	for (NSDictionary *dictionary in dictionaries) {
		id tmpObject = [self createObject:[[[object class] allocWithZone:nil] init] fromDictionary:dictionary];
		[arrayOfObjects addObject:tmpObject];
	}
	
	return arrayOfObjects;
}

/*
 *
 */
+ (NSDictionary *)createDictionaryWithObject:(NSObject *)object {
	
	// Get the properties of the object from the Objective C runtime
	NSArray *properties = [self propertiesFromObject:object];
	
	NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:[properties count]];
	
	// For all of the properties that the object holds, set the values from the dictionary
	for (int i = 0; i < [properties count]; i++) {
		NSString *key = [properties objectAtIndex:i];
		if (![key hasPrefix:@"_type_"]) {
			NSObject *value = [object performSelector:NSSelectorFromString(key)];
			if ([value isKindOfClass:[NSArray class]]) {
				// implement
			} else {
				[mutableDictionary setValue:value forKey:key];
			}
		}
		
	}
	
	NSDictionary *dic = [self manipulateDictionaryKeysWhenFromObject:mutableDictionary];

	return dic;
}

/*
 *
 */
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
 * This method replaces the keys for the dictionary with the values for the keys specified 
 * in the language dictionary.
 *
 * e.g. if the language dictionary contains one item with a key of 'id' and a value of '_id', then the resulting
 * dictionary will have its 'id' key changed to '_id'.
 */

+ (NSDictionary *)manipulateDictionaryKeys:(NSDictionary *)dictionary withDictionary:(NSDictionary *)language {
	
	NSEnumerator *enumerator = [language keyEnumerator];
	id key;
	
	// Create a Dictionary from the existing one and replace the keys
	NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
	
	while ((key = [enumerator nextObject])) {
		
		// Check if the Dictionary contains the reserved word
		id object = [dictionary objectForKey:key];
		if (object != nil) {
			[mutableDictionary removeObjectForKey:key];
			[mutableDictionary setObject:object forKey:[language objectForKey:key]];
		}
		
	}
	
	NSDictionary *newDictionary = [NSDictionary dictionaryWithDictionary:mutableDictionary];
	[mutableDictionary release];
	return newDictionary;
}

/*
 * This method removes underscores '_' from the dictionary keys that are reserved words in the language.
 */
+ (NSDictionary *)manipulateDictionaryKeysWhenToObject:(NSDictionary *)dictionary {
	NSDictionary *language = [NSDictionary dictionaryWithObject:@"_id" forKey:@"id"];
	return [self manipulateDictionaryKeys:dictionary withDictionary:language];
}

/*
 * This method adds underscores '_' to the dictionary keys that are reserved words in the language.
 */
+ (NSDictionary *)manipulateDictionaryKeysWhenFromObject:(NSDictionary *)dictionary {
	NSDictionary *language = [NSDictionary dictionaryWithObject:@"id" forKey:@"_id"];
	return [self manipulateDictionaryKeys:dictionary withDictionary:language];
}



@end
