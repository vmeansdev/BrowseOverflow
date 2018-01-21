//
//  QuestionBuilderTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 19/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestConsts.h"
#import "QuestionBuilder.h"
#import "Question.h"
#import "Person.h"

@interface QuestionBuilderTests : XCTestCase

@end

@implementation QuestionBuilderTests{
    QuestionBuilder *questionBuilder;
    Question *question;
}

- (void)setUp {
    [super setUp];
    questionBuilder = [[QuestionBuilder alloc] init];
    question = [questionBuilder questionsFromJSON:questionJSON error:NULL][0];
}

- (void)tearDown {
    questionBuilder = nil;
    question = nil;
    [super tearDown];
}

- (void)testThatNilIsNotAnAcceptableParameter{
    XCTAssertThrows([questionBuilder questionsFromJSON:nil error:NULL],
                    @"Lack of data should have been tested elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJSON{
    XCTAssertNil([questionBuilder questionsFromJSON:kNotJSON error:NULL],
                 @"This parameter should not be parsable");
}

- (void)testErrorSetWhenStringIsNotJSON{
    NSError *error = nil;
    [questionBuilder questionsFromJSON:kNotJSON error:&error];
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash{
    XCTAssertNoThrow([questionBuilder questionsFromJSON:kNotJSON error:NULL],
                     @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutQuestionsArrayIsError{
    NSString *jsonString = kNoQuestions;
    XCTAssertNil([questionBuilder questionsFromJSON:jsonString error:NULL],
                 @"No questions to parse in this JSON");
}

- (void)testRealJSONWithoutQuestionsReturnsMissingDataError {
    NSString *jsonString = kNoQuestions;
    NSError *error = nil;
    [questionBuilder questionsFromJSON:jsonString error:&error];
    XCTAssertEqual(error.code, QuestionBuilderMissingDataError,
                   @"This case should not be an invalid JSON error");
}

- (void)testJSONWithOneQuestionReturnsOneQuestionObject {
    NSError *error = nil;
    NSArray *questions = [questionBuilder questionsFromJSON:questionJSON error:&error];
    XCTAssertEqual([questions count], (NSUInteger)1,
                   @"The builder should have created a question");
}

- (void)testQuestionCreatedFromJSONHasPropertiesPresentedInJSON {
    XCTAssertEqual(question.questionID, 48366718,
                   @"The question ID should match the data we sent");
    XCTAssertEqual([question.date timeIntervalSince1970], (NSTimeInterval)1516537479,
                   @"The date of the question should match the data");
    XCTAssertEqualObjects(question.title, @"Custom TableViewCell GooglePlace AutoCompletion",
                          @"Title should match the provided data");
    XCTAssertEqual(question.score, 0,
                   @"Score should match the data");
    Person *asker = question.asker;
    XCTAssertEqualObjects(asker.name, @"Shawon91",
                          @"Looks like someone should have asked this question");
    XCTAssertEqualObjects([asker.avatarURL absoluteString], @"https://www.gravatar.com/avatar/d6c619843e14daa6cc1484f3f076a05b?s=128&d=identicon&r=PG&f=1",
                          @"The avatar URL should be there");
}

- (void)testQuestionCreatedFromEmptyObjectsIsStillValidObject {
    NSString *emptyQuestion = @"{ \"items\": [ {} ] }";
    NSArray *questions = [questionBuilder questionsFromJSON:emptyQuestion error:NULL];
    XCTAssertEqual([questions count], (NSUInteger)1,
                   @"QuestionBuilder must handle partial input");
}

- (void)testBuildingQuestionBodyWithNoDataCannotBeTried {
    XCTAssertThrows([questionBuilder fillInDetailsForQuestion:question fromJSON:nil],
                    @"Not receiving data should have been handled earlier");
}

- (void)testBuildingQuestionBodyWithNoQuestionCannotBeTried {
    XCTAssertThrows([questionBuilder fillInDetailsForQuestion:nil fromJSON:questionJSON],
                    @"No reason to expect that a nil question is passed");
}

- (void)testNonJSONDataDoesNotCauseABodyToBeAddedToAQuestion {
    NSString *stringIsNotJSON = @"Hello, World!";
    [questionBuilder fillInDetailsForQuestion:question fromJSON:stringIsNotJSON];
    XCTAssertNil(question.body, @"Body should not have been added");
}

- (void)testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded {
    NSString *noQuestionsJSONString = @"{\"items\":[]}";
    [questionBuilder fillInDetailsForQuestion:question fromJSON:noQuestionsJSONString];
    XCTAssertNil(question.body, @"There was no body to add");
}

- (void)testBodyContainedInJSONIsAddedToQuestion {
    [questionBuilder fillInDetailsForQuestion:question fromJSON:questionJSON];
    XCTAssertEqualObjects(question.body, @"<p>Google Provides pretty clear code samples to implement google map and google places in application. But also it's natural that it wont fulfill everyone's need. </p>\n\n<p>I want to implement goole places autocompletion with 2 section. In 1st i want to add 2 rows - like my current location &amp; show on map, and on second there will be autocomplete suggestion. But TableView Cell given in the demo has 2 Strings one primary Attribute of place &amp; the secondary attribute. What if one wants to add only just the name of the place. Is the cell customizable ? Is the table customizable ? </p>\n",
                          @"The correct question body is added");
}

static NSString *questionJSON =
@"{"
@"  \"items\": ["
@"    {"
@"      \"tags\": ["
@"        \"ios\","
@"        \"objective-c\","
@"        \"iphone\""
@"      ],"
@"      \"owner\": {"
@"        \"reputation\": 56,"
@"        \"user_id\": 2800066,"
@"        \"user_type\": \"registered\","
@"        \"accept_rate\": 0,"
@"        \"profile_image\": \"https://www.gravatar.com/avatar/d6c619843e14daa6cc1484f3f076a05b?s=128&d=identicon&r=PG&f=1\","
@"        \"display_name\": \"Shawon91\","
@"        \"link\": \"https://stackoverflow.com/users/2800066/shawon91\""
@"      },"
@"      \"is_answered\": false,"
@"      \"view_count\": 3,"
@"      \"answer_count\": 0,"
@"      \"score\": 0,"
@"      \"last_activity_date\": 1516537479,"
@"      \"creation_date\": 1516537479,"
@"      \"question_id\": 48366718,"
@"      \"link\": \"https://stackoverflow.com/questions/48366718/custom-tableviewcell-googleplace-autocompletion\","
@"      \"title\": \"Custom TableViewCell GooglePlace AutoCompletion\","
@"      \"body\": \"<p>Google Provides pretty clear code samples to implement google map and google places in application. But also it's natural that it wont fulfill everyone's need. </p>\\n\\n<p>I want to implement goole places autocompletion with 2 section. In 1st i want to add 2 rows - like my current location &amp; show on map, and on second there will be autocomplete suggestion. But TableView Cell given in the demo has 2 Strings one primary Attribute of place &amp; the secondary attribute. What if one wants to add only just the name of the place. Is the cell customizable ? Is the table customizable ? </p>\\n\""
@"    }"
@"  ],"
@"  \"has_more\": true,"
@"  \"quota_max\": 10000,"
@"  \"quota_remaining\": 9968"
@"}";

@end
