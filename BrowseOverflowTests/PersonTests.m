//
//  PersonTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 17/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

@interface PersonTests : XCTestCase

@end

@implementation PersonTests{
    Person *person;
}

- (void)setUp {
    [super setUp];
    person = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
}

- (void)tearDown {
    person = nil;
    [super tearDown];
}

- (void)testThatPersonHasTheRightName{
    XCTAssertEqualObjects(person.name, @"Graham Lee",
                          @"expecting a person to provide its name");
}

- (void)testThatPersonHasAnAvatarURL{
    NSURL *url = person.avatarURL;
    XCTAssertEqualObjects([url absoluteString], @"http://example.com/avatar.png",
                          @"The person's avatar should be presented by a URL");
}

@end
