//
//  AnswerBuilderTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 31/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestConsts.h"
#import "Question.h"
#import "Answer.h"

#import "AnswerBuilder.h"

@interface AnswerBuilderTests : XCTestCase

@end

@implementation AnswerBuilderTests{
    AnswerBuilder *answerBuilder;
    Question *question;
}

- (void)setUp {
    [super setUp];
    answerBuilder = [[AnswerBuilder alloc] init];
    question = [[Question alloc] init];
    question.questionID = 12345;
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testThatNilIsNotAnAcceptableParameter{
    XCTAssertThrows([answerBuilder addAnswersToQuestion:question fromJSON:nil error:NULL],
                    @"Not having data should already been handled");
}

- (void)testThatAddingAnswersToNilQuestionIsNotSupported {
    XCTAssertThrows([answerBuilder addAnswersToQuestion: nil fromJSON:kNotJSON error: NULL],
                    @"Makes no sense to have answers without a question");
}

- (void)testErrorSetWhenStringIsNotJSON{
    NSError *error = nil;
    XCTAssertFalse([answerBuilder addAnswersToQuestion:question fromJSON:kNotJSON error:&error],
                   @"Can't successfully create answers without real data");
    XCTAssertEqualObjects(error.domain, AnswerBuilderErrorDomain,
                          @"This should be an AnswerBuilder error");
}

- (void)testPassingNullErrorDoesNotCauseCrash{
    XCTAssertNoThrow([answerBuilder addAnswersToQuestion:question fromJSON:kNotJSON error:NULL],
                     @"Using a NULL error parameter should not be a problem");
}

- (void)testSendingJSONWithIncorrectKeysIsAnError {
    NSError *error = nil;
    XCTAssertFalse([answerBuilder addAnswersToQuestion:question fromJSON: kNoAnswers error: &error],
                   @"There must be a collection of answers in the input data");
}

- (void)testAddingRealAnswerJSONIsNotAnError {
    XCTAssertTrue([answerBuilder addAnswersToQuestion: question fromJSON:answerJSON error: NULL],
                  @"Should be OK to actually want to add answers");
}

- (void)testNumberOfAnswersAddedMatchNumberInData {
    [answerBuilder addAnswersToQuestion: question fromJSON:answerJSON error: NULL];
    XCTAssertEqual([question.answers count], (NSUInteger)1,
                   @"One answer added to zero should mean one answer");
}

- (void)testAnswerPropertiesMatchDataReceived {
    [answerBuilder addAnswersToQuestion: question fromJSON:answerJSON error: NULL];
    Answer *answer = [question.answers objectAtIndex: 0];
    XCTAssertEqual(answer.score, (NSInteger)0,
                   @"Score property should be set from JSON");
    XCTAssertTrue(answer.accepted,
                  @"Answer should be accepted as in JSON data");
    XCTAssertEqualObjects(answer.text,
                          @"<p>I believe the reason your code doesn't work is that it has an error. <code>Message.photo</code> is actually a list of different photo sizes, so\n<code>file_id=update.channel_post.photo.file_id</code> should be <code>file_id=update.channel_post.photo[-1].file_id</code> (to get the biggest size)</p>\n\n<p>I also recommend you enable logging, so you will see errors like this more easily.</p>\n\n<pre><code>import logging\nlogging.basicConfig(level=logging.INFO,\n                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')\n</code></pre>\n",
                          @"Answer body should match fed data");
}

- (void)testAnswerIsProvidedByExpectedPerson {
    [answerBuilder addAnswersToQuestion: question fromJSON:answerJSON error: NULL];
    Answer *answer = [question.answers objectAtIndex: 0];
    Person *answerer = answer.person;
    XCTAssertEqualObjects(answerer.name, @"jh0ker",
                          @"The provided person name was used");
    XCTAssertEqualObjects([answerer.avatarURL absoluteString],
                          @"https://www.gravatar.com/avatar/c29cb7936c646f1919cc168d562e3f49?s=128&d=identicon&r=PG",
                          @"The provided email hash was converted to an avatar URL");
}

static NSString *answerJSON =
@"{"
@"  \"items\": ["
@"    {"
@"      \"owner\": {"
@"        \"reputation\": 71,"
@"        \"user_id\": 1398961,"
@"        \"user_type\": \"registered\","
@"        \"profile_image\": \"https://www.gravatar.com/avatar/c29cb7936c646f1919cc168d562e3f49?s=128&d=identicon&r=PG\","
@"        \"display_name\": \"jh0ker\","
@"        \"link\": \"https://stackoverflow.com/users/1398961/jh0ker\""
@"      },"
@"      \"is_accepted\": true,"
@"      \"score\": 0,"
@"      \"last_activity_date\": 1516729830,"
@"      \"creation_date\": 1516729830,"
@"      \"answer_id\": 48407922,"
@"      \"question_id\": 48366720,"
@"      \"body\": \"<p>I believe the reason your code doesn't work is that it has an error. <code>Message.photo</code> is actually a list of different photo sizes, so\\n<code>file_id=update.channel_post.photo.file_id</code> should be <code>file_id=update.channel_post.photo[-1].file_id</code> (to get the biggest size)</p>\\n\\n<p>I also recommend you enable logging, so you will see errors like this more easily.</p>\\n\\n<pre><code>import logging\\nlogging.basicConfig(level=logging.INFO,\\n                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')\\n</code></pre>\\n\""
@"    }"
@"  ],"
@"  \"has_more\": false,"
@"  \"quota_max\": 10000,"
@"  \"quota_remaining\": 9988"
@"}";
@end
