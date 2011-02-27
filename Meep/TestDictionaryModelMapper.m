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
#import "ObjectWithProperties.h"

@implementation TestDictionaryModelMapper

- (void)testCreateObjectFromDictionary {
	
	NSString *accessTokenKey = @"accessToken";
	NSString *accessToken = @"123";
	NSString *emailKey = @"email";
	NSString *email = @"test@test.com";
	
	User *user = [[User alloc] init];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								accessToken, accessTokenKey,
								email, emailKey, nil];
	
	user = [DictionaryModelMapper createObject:user fromDictionary:dictionary];
	
	STAssertEquals(user.accessToken, [dictionary valueForKey:accessTokenKey], @"Object string equals dictionary string", nil);
	STAssertEquals(user.email, [dictionary valueForKey:emailKey], @"Object string equals dictionary string", nil);
	
	[user release];
}

- (void)testManipulateDictionaryKeysToObject {
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"1" forKey:@"id"];
	NSDictionary *dictionary2 = [DictionaryModelMapper manipulateDictionaryKeysWhenToObject:dictionary];
	
	STAssertEquals([dictionary objectForKey:@"id"], [dictionary2 objectForKey:@"_id"], @"Objects have changed keys from 'id' to '_id'", nil);
}

- (void)testManipulateDictionaryKeysFromObject {
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"1" forKey:@"_id"];
	NSDictionary *dictionary2 = [DictionaryModelMapper manipulateDictionaryKeysWhenFromObject:dictionary];
	
	STAssertEquals([dictionary objectForKey:@"_id"], [dictionary2 objectForKey:@"id"], @"Objects have changed keys from '_id' to 'id'", nil);
}

- (void)testCreateObjectWithIdAttribute {
	
	ObjectWithId *objectWithId = [[ObjectWithId alloc] init];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"1" forKey: @"id"];
	
	[DictionaryModelMapper createObject:objectWithId fromDictionary:dictionary];
	
	STAssertEquals(objectWithId._id, [dictionary valueForKey:@"_id"], @"'_id' attribute of object equals 'id' of dictionary", nil);
}

- (void)testCreateArrayOfObjectsFromArrayOfDictionaries {
	
	NSString *_idKey = @"id";
	NSString *_id = @"1";
	
	ObjectWithId *object = [[ObjectWithId alloc] init];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: _id, _idKey, nil];
	NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys: _id, _idKey, nil];
	
	NSArray *arrayOfDictionaries = [NSArray arrayWithObjects:dictionary, dictionary2, nil];
	
	NSArray *arrayOfObjects = [DictionaryModelMapper createArrayOfObjects:object fromArrayOfDictionaries:arrayOfDictionaries];
	
	NSUInteger expectedCount = 2;
	STAssertEquals(expectedCount, [arrayOfObjects count], @"ArrayOfObjects should be of length 2", nil);
	
}

- (void)testCreateDictionaryFromObject {
	
	ObjectWithProperties *objectWithProperties = [[ObjectWithProperties alloc] init];
	NSNumber *number = [NSNumber numberWithInt:1];
	objectWithProperties._id = number;
	objectWithProperties.firstName = @"Alex";
	objectWithProperties.lastName = @"Jarvis";
	
	NSDictionary *dictionary = [DictionaryModelMapper createDictionaryWithObject:objectWithProperties];
	
	NSUInteger expectedCount = 3;
	STAssertEquals(expectedCount, [dictionary count], @"NSDictionary is not the required size", nil);
	STAssertEquals(number, [dictionary objectForKey:@"id"], @"NSDictionary value does not equal objects", nil);
	STAssertEquals(@"Alex", [dictionary objectForKey:@"firstName"], @"NSDictionary value does not equal objects", nil);
	STAssertEquals(@"Jarvis", [dictionary objectForKey:@"lastName"], @"NSDictionary value does not equal objects", nil);
}


@end
