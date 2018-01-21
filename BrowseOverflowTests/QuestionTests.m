//
//  QuestionTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 16/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Question.h"
#import "Answer.h"
#import "Person.h"

@interface QuestionTests : XCTestCase

@end

@implementation QuestionTests{
    Question *question;
    Answer *lowScore;
    Answer *highScore;
    Person *asker;
}

- (void)setUp {
    [super setUp];
    asker = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
    
    question = [[Question alloc] init];
    question.date = [NSDate distantPast];
    question.title = @"Do iPhones also dream of electric sheep?";
    question.score = 42;
    question.asker = asker;
    
    lowScore = [[Answer alloc] init];
    lowScore.score = -4;
    [question addAnswer:lowScore];
    
    highScore = [[Answer alloc] init];
    highScore.score = 4;
    highScore.accepted = YES;
    [question addAnswer:highScore];
}

- (void)tearDown {
    question = nil;
    lowScore = nil;
    highScore = nil;
    [super tearDown];
}

- (void)testQuestionHasADate{
    NSDate *testDate = [NSDate distantPast];
    question.date = testDate;
    XCTAssertEqualObjects(question.date, testDate,
                          @"Question needs to provide its test date");
}

- (void)testQuestionsKeepScore{
    XCTAssertEqual(question.score, 42,
                   @"Questions need a numeric score");
}

- (void)testQuestionHasATitle{
    XCTAssertEqualObjects(question.title, @"Do iPhones also dream of electric sheep?",
                          @"Question should know its title");
}

- (void)testQuestionCanHaveAnswersAdded{
    Answer *answer = [[Answer alloc] init];
    XCTAssertNoThrow([question addAnswer:answer],
                     @"Must be able to add answers");
}

- (void)testAcceptedAnswerIsFirst{
    XCTAssertTrue([question.answers[0] isAccepted],
                  @"Accepted answer comes first");
}

- (void)testHighScoreAnswerBeforeLow {
    NSArray *answers = question.answers;
    NSInteger highIndex = [answers indexOfObject:highScore];
    NSInteger lowIndex = [answers indexOfObject:lowScore];
    XCTAssertTrue(highIndex < lowIndex,
                  @"High-scoring answer comes first");
}

- (void)testQuestionWasAskedBySomeone{
    XCTAssertEqualObjects(question.asker, asker,
                          @"Question should keep track of who asked it.");
}

@end
