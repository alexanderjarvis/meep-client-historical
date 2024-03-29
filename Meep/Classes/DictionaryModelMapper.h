//
//  DictionaryModelMapper.h
//  Meep
//
//  Created by Alex Jarvis on 11/02/2011.
//  Copyright 2011 Alex Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryModelMapper : NSObject {

}

+ (id)createObject:(NSObject *)object fromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)createArrayOfObjects:(NSObject *)object fromArrayOfDictionaries:(NSArray *)dictionaries;

+ (NSDictionary *)createDictionaryWithObject:(NSObject *)object;

+ (NSArray *)createArrayOfDictionariesFromArrayOfObjects:(NSArray *)objects ofType:(NSObject *)objectType;

+ (NSArray *)propertiesFromObject:(NSObject *)object;

+ (NSDictionary *)manipulateDictionaryKeys:(NSDictionary *)dictionary withDictionary:(NSDictionary *)language;

+ (NSDictionary *)manipulateDictionaryKeysWhenToObject:(NSDictionary *)dictionary;

+ (NSDictionary *)manipulateDictionaryKeysWhenFromObject:(NSDictionary *)dictionary;


@end
