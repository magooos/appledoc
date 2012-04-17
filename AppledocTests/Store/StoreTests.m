//
//  StoreTests.m
//  appledoc
//
//  Created by Tomaž Kragelj on 4/12/12.
//  Copyright (c) 2012 Tomaz Kragelj. All rights reserved.
//

#import "Store.h"
#import "TestCaseBase.h"

@interface Store (UnitTestingPrivateAPI)
@property (nonatomic, strong) NSMutableArray *registrationStack;
@end

#pragma mark - 

@interface StoreTests : TestCaseBase
@end

@interface StoreTests (CreationMethods)
- (void)runWithStore:(void(^)(Store *store))handler;
@end

@implementation StoreTests

#pragma mark - Verify lazy initialization

- (void)testLazyInitializationWorks {
	[self runWithStore:^(Store *store) {
		// execute & verify
		assertThat(store.registrationStack, instanceOf([NSMutableArray class]));
	}];
}

#pragma mark - Verify handling of classes, categories and protocols

- (void)testBeginClassWithNameDerivedFromClassWithNameShouldRegisterClassInfo {
	[self runWithStore:^(Store *store) {
		// setup & execute
		[store beginClassWithName:@"Name" derivedFromClassWithName:@"Derived"];
		// verify
		assertThat(store.currentRegistrationObject, instanceOf([ClassInfo class]));
		assertThat([store.currentRegistrationObject nameOfClass], equalTo(@"Name"));
		assertThat([store.currentRegistrationObject nameOfSuperClass], equalTo(@"Derived"));
		assertThat([store.currentRegistrationObject objectRegistrar], equalTo(store));
	}];
}

- (void)testBeginExtensionForClassWithNameShouldRegisterCategoryInfo {
	[self runWithStore:^(Store *store) {
		// setup & execute
		[store beginExtensionForClassWithName:@"Name"];
		// verify
		assertThat(store.currentRegistrationObject, instanceOf([CategoryInfo class]));
		assertThat([store.currentRegistrationObject nameOfClass], equalTo(@"Name"));
		assertThat([store.currentRegistrationObject nameOfCategory], equalTo(nil));
		assertThat([store.currentRegistrationObject objectRegistrar], equalTo(store));
	}];
}

- (void)testBeginCategoryWithNameForClassWithNameShouldRegisterCategoryInfo {
	[self runWithStore:^(Store *store) {
		// setup & execute
		[store beginCategoryWithName:@"Category" forClassWithName:@"Name"];
		// verify
		assertThat(store.currentRegistrationObject, instanceOf([CategoryInfo class]));
		assertThat([store.currentRegistrationObject nameOfClass], equalTo(@"Name"));
		assertThat([store.currentRegistrationObject nameOfCategory], equalTo(@"Category"));
		assertThat([store.currentRegistrationObject objectRegistrar], equalTo(store));
	}];
}

- (void)testBeginProtocolWithNameShouldRegisterProtocolInfo {
	[self runWithStore:^(Store *store) {
		// setup & execute
		[store beginProtocolWithName:@"Name"];
		// verify		
		assertThat(store.currentRegistrationObject, instanceOf([ProtocolInfo class]));
		assertThat([store.currentRegistrationObject nameOfProtocol], equalTo(@"Name"));
		assertThat([store.currentRegistrationObject objectRegistrar], equalTo(store));
	}];
}

- (void)testAppendAdoptedProtocolShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendAdoptedProtocolWithName:@"name"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendAdoptedProtocolWithName:@"name"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

#pragma mark - Verify forwarding of method group related messages

- (void)testAppendMethodGroupWithDescriptionShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendMethodGroupWithDescription:@"description"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendMethodGroupWithDescription:@"description"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

#pragma mark - Verify forwarding of property related messages

- (void)testBeginPropertyDefinitionShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] beginPropertyDefinition];
		[store pushRegistrationObject:mock];
		// execute
		[store beginPropertyDefinition];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testBeginPropertyAttributesShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] beginPropertyAttributes];
		[store pushRegistrationObject:mock];
		// execute
		[store beginPropertyAttributes];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testAppendPropertyNameShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendPropertyName:@"name"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendPropertyName:@"name"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

#pragma mark - Verify forwarding of method related messages

- (void)testBeginMethodDefinitionWithTypeShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] beginMethodDefinitionWithType:@"type"];
		[store pushRegistrationObject:mock];
		// execute
		[store beginMethodDefinitionWithType:@"type"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testBeginMethodResultsShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] beginMethodResults];
		[store pushRegistrationObject:mock];
		// execute
		[store beginMethodResults];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testBeginMethodArgumentShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] beginMethodArgument];
		[store pushRegistrationObject:mock];
		// execute
		[store beginMethodArgument];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testAppendMethodArgumentSelectorShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendMethodArgumentSelector:@"selector"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendMethodArgumentSelector:@"selector"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testAppendMethodArgumentVariableShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendMethodArgumentVariable:@"variable"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendMethodArgumentVariable:@"variable"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

#pragma mark - Verify handling of enumeration related messages

- (void)testBeginEnumerationShouldRegisterEnumInfo {
	[self runWithStore:^(Store *store) {
		// TODO!!! STFail(@"not implemented!");
	}];
}

- (void)testAppendEnumerationItemShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendEnumerationItem:@"value"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendEnumerationItem:@"value"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testAppendEnumerationValueShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendEnumerationValue:@"value"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendEnumerationValue:@"value"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

#pragma mark - Verify handling of struct related messages

- (void)testBeginStructShouldRegistrStructInfo {
	[self runWithStore:^(Store *store) {
		// TODO!!! STFail(@"not implemented!");
	}];
}

#pragma mark - Verify handling of constant related messages

- (void)testBeginConstantShouldRegisterConstantInfoIfRegistrationStackIsEmpty {
	[self runWithStore:^(Store *store) {
		// TODO!!! STFail(@"not implemented!");
	}];
}

- (void)testBeginConstantShouldForwardToCurrentObjectIfAvailable {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] beginConstant];
		[store pushRegistrationObject:mock];
		// execute
		// TODO!!! [store beginConstant];
		// verify
		// TODO!!! STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testAppendConstantTypeShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendConstantType:@"value"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendConstantType:@"value"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

- (void)testAppendConstantNameShouldForwardToCurrentObject {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] appendConstantName:@"value"];
		[store pushRegistrationObject:mock];
		// execute
		[store appendConstantName:@"value"];
		// verify
		STAssertNoThrow([mock verify], nil);
	}];
}

#pragma mark - endCurrentObject

- (void)testEndCurrentObjectShouldForwardToCurrentObjectIfItRespondsToEndMessageThenRemoveObjectFromRegistrationStack {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] endCurrentObject];
		[store pushRegistrationObject:mock];
		// execute
		[store endCurrentObject];
		// verify
		STAssertNoThrow([mock verify], nil);
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
	}];
}

- (void)testEndCurrentObjectShouldNotForwardToCurrentObjectIfItDoesntRespondToEndMessageThenRemoveObjectFromRegistrationStack {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = @"object";
		[store pushRegistrationObject:mock];
		// execute - note that in case we send endCurrentObject, this should fail due to NSString not implementing the method!
		[store endCurrentObject];
		// verify
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
	}];
}

- (void)testEndCurrentObjectShouldIgnoreIfRegistrationStackIsEmpty {
	[self runWithStore:^(Store *store) {
		// execute
		[store endCurrentObject];
		// verify - real code logs a warning, but we don't test that here
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
	}];
}

#pragma mark - cancelCurrentObject

- (void)testCancelCurrentObjectShouldForwardToCurrentObjectIfItRespondsToEndMessageThenRemoveObjectFromRegistrationStack {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = [OCMockObject mockForClass:[Store class]];
		[[mock expect] cancelCurrentObject];
		[store pushRegistrationObject:mock];
		// execute
		[store cancelCurrentObject];
		// verify
		STAssertNoThrow([mock verify], nil);
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
	}];
}

- (void)testCancelCurrentObjectShouldNotForwardToCurrentObjectIfItDoesntRespondToEndMessageThenRemoveObjectFromRegistrationStack {
	[self runWithStore:^(Store *store) {
		// setup
		id mock = @"object";
		[store pushRegistrationObject:mock];
		// execute - note that in case we send endCurrentObject, this should fail due to NSString not implementing the method!
		[store cancelCurrentObject];
		// verify
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
	}];
}

- (void)testCancelCurrentObjectShouldIgnoreIfRegistrationStackIsEmpty {
	[self runWithStore:^(Store *store) {
		// execute
		[store cancelCurrentObject];
		// verify - real code logs a warning, but we don't test that here
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
	}];
}

#pragma mark - Verify registration stack handling

- (void)testPushRegistrationObjectShouldAddObjectToRegistrationStack {
	[self runWithStore:^(Store *store) {
		// setup
		id child = @"child";
		// execute
		[store pushRegistrationObject:child];
		// verify
		assertThatInt(store.registrationStack.count, equalToInt(1));
		assertThat([store.registrationStack lastObject], equalTo(child));
		assertThat(store.currentRegistrationObject, equalTo(child));
	}];
}

- (void)testPushRegistrationObjectShouldMultipleObjectsToRegistrationStack {
	[self runWithStore:^(Store *store) {
		// setup
		id child1 = @"child1";
		id child2 = @"child2";
		// execute
		[store pushRegistrationObject:child1];
		[store pushRegistrationObject:child2];
		// verify
		assertThatInt(store.registrationStack.count, equalToInt(2));
		assertThat([store.registrationStack objectAtIndex:0], equalTo(child1));
		assertThat([store.registrationStack objectAtIndex:1], equalTo(child2));
		assertThat(store.currentRegistrationObject, equalTo(child2));
	}];
}

- (void)testPopRegistrationObjectShouldRemoveLastObjectFromRegistrationStackWithMultipleObjects {
	[self runWithStore:^(Store *store) {
		// setup
		id child1 = @"child1";
		id child2 = @"child2";
		[store pushRegistrationObject:child1];
		[store pushRegistrationObject:child2];
		// execute
		id poppedObject = [store popRegistrationObject];
		// verify
		assertThatInt(store.registrationStack.count, equalToInt(1));
		assertThat([store.registrationStack lastObject], equalTo(child1));
		assertThat(store.currentRegistrationObject, equalTo(child1));
		assertThat(poppedObject, equalTo(child2));
	}];
}

- (void)testPopRegistrationObjectShouldRemoveLastObjectFromRegistrationStackWithSingleObjects {
	[self runWithStore:^(Store *store) {
		// setup
		id child = @"child1";
		[store pushRegistrationObject:child];
		// execute
		id poppedObject = [store popRegistrationObject];
		// verify
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
		assertThat(poppedObject, equalTo(child));
	}];
}

- (void)testPopRegistrationObjectShouldDoNothingIfRegistrationStackIsEmpty {
	[self runWithStore:^(Store *store) {
		// execute
		id poppedObject = [store popRegistrationObject];
		// verify - note that in this case we log a warning, but we don't test that...
		assertThatInt(store.registrationStack.count, equalToInt(0));
		assertThat(store.currentRegistrationObject, equalTo(nil));
		assertThat(poppedObject, equalTo(nil));
	}];
}

@end

#pragma mark - 

@implementation StoreTests (CreationMethods)

- (void)runWithStore:(void(^)(Store *store))handler {
	Store *store = [Store new];
	handler(store);
}

@end
