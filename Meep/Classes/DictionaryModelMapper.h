//
//  DictionaryModelMapper.h
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryModelMapper : NSObject {

}

+ (id)createObject:(NSObject *)object fromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)createArrayOfObjects:(NSObject *)object fromArrayOfDictionaries:(NSArray *)dictionaries;

+ (NSArray *)propertiesFromObject:(NSObject *)object;

+ (NSDictionary *)manipulateDictionaryKeysForLanguageKeywords:(NSDictionary *)dictionary;

@end
