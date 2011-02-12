//
//  TestDictionaryModelMapper.m
//  Meep
//
//  Created by Alex Jarvis on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestDictionaryModelMapper.h"

#import "DictionaryModelMapper.h"
#import "User.h"
#import "ObjectWithId.h"

@implementation TestDictionaryModelMapper

- (void) testCreateObjectFromDictionary {
	
	NSString *accessTokenKey = @"accessToken";
	NSString *accessToken = @"123";
	NSString *emailKey = @"email";
	NSString *email = @"test@test.com";
	
	User *user = [[User alloc] init];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								accessToken, accessTokenKey,
								email, emailKey, nil];
	
	[DictionaryModelMapper createObject:user fromDictionary:dictionary];
	
	STAssertEquals(user.accessToken, [dictionary valueForKey:accessTokenKey], @"Object string equals dictionary string", nil);
	STAssertEquals(user.email, [dictionary valueForKey:emailKey], @"Object string equals dictionary string", nil);
	
	[user release];
}

- (void) testManipulateDictionaryKeysForLanguageKeywords {
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"1" forKey:@"id"];
	NSDictionary *dictionary2 = [DictionaryModelMapper manipulateDictionaryKeysForLanguageKeywords:dictionary];
	
	STAssertEquals([dictionary objectForKey:@"id"], [dictionary2 objectForKey:@"_id"], @"Objects have changed keys from 'id' to '_id'", nil);
}

- (void) testCreateObjectWithIdAttribute {
	
	NSString *_idKey = @"id";
	NSString *_id = @"1";
	
	ObjectWithId *objectWithId = [[ObjectWithId alloc] init];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: _id, _idKey, nil];
	
	[DictionaryModelMapper createObject:objectWithId fromDictionary:dictionary];
	
	STAssertEquals(objectWithId._id, [dictionary valueForKey:_idKey], @"'_id' attribute of object equals 'id' of dictionary", nil);
}


@end
