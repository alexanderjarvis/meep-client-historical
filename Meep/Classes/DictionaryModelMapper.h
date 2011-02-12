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

+ (void)createObject:(NSObject *)object fromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)propertiesFromObject:(NSObject *)object;

+ (NSDictionary *)manipulateDictionaryKeysForLanguageKeywords:(NSDictionary *)dictionary;

@end
