//
//  AnswerTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Answer.h"
#import "Person.h"

@interface AnswerTests : XCTestCase

@end

@implementation AnswerTests{
    Answer *answer;
    Answer *otherAnswer;
}

- (void)setUp {
    [super setUp];
    answer = [[Answer alloc] init];
    answer.text = @"The answer is 42";
    answer.person = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
    answer.score = 42;
    
    otherAnswer = [[Answer alloc] init];
    otherAnswer.text = @"I have the answer you need";
    otherAnswer.score = 42;
}

- (void)tearDown {
    answer = nil;
    [super tearDown];
}

- (void)testAnswerHasSomeText{
    XCTAssertEqualObjects(answer.text, @"The answer is 42",
                          @"Answer need to contain some text");
}

- (void)testSomeoneProvidedTheAnswer{
    XCTAssertTrue([answer.person isKindOfClass:[Person class]],
                  @"A person gave this answer");
}

- (void)testAnswersNotAcceptedByDefault{
    XCTAssertFalse(answer.accepted,
                   @"Answer not accepted by default");
}

- (void)testAnswerCanBeAccepted{
    XCTAssertNoThrow(answer.accepted = YES,
                     @"It is possible to accept an answer");
}

- (void)testAnswerHasAScore{
    XCTAssertTrue(answer.score == 42,
                  @"Answer's score can be retreived");
}

- (void)testAcceptedAnswerComesBeforeUnaccepted{
    otherAnswer.accepted = YES;
    otherAnswer.score = answer.score + 10;
    
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedDescending,
                   @"Accepted answer should come first");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedAscending,
                   @"Unaccepted answer should come last");
}


- (void)testAnswersWithEqualScoresCompareEqually{
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedSame,
                   @"Both answers of equal rank");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedSame,
                   @"Each answer has the same rank");
}

- (void)testLowerScoringAnswerComesAfterHigher {
    otherAnswer.score = answer.score + 10;
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedDescending,
                   @"Higher score comes first");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedAscending,
                   @"Lower score comes last");
}

@end
