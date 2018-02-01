//
//  QuestionCreationTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StackOverflowManager.h"
#import "MockStackOverflowManagerDelegate.h"
#import "MockStackOverflowCommunicator.h"
#import "TestConsts.h"

#import "Topic.h"
#import "Question.h"

#import "FakeQuestionBuilder.h"


@interface QuestionCreationTests : XCTestCase

@end

@implementation QuestionCreationTests{
@private
    StackOverflowManager *mgr;
    MockStackOverflowCommunicator *communicator;
    MockStackOverflowManagerDelegate *delegate;
    FakeQuestionBuilder *questionBuilder;
    NSError *underlyingError;
    NSArray *questionArray;
    
    Question *questionToFetch;
}

- (void)setUp {
    [super setUp];
    mgr = [[StackOverflowManager alloc] init];
    delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    underlyingError = [NSError errorWithDomain:kTestDomain
                                          code:0 userInfo:nil];
    
    questionToFetch = [[Question alloc] init];
    questionToFetch.questionID = 1234;
    questionArray = @[questionToFetch];
    
    questionBuilder = [[FakeQuestionBuilder alloc] init];
    mgr.questionBuilder = questionBuilder;
    
    communicator = [[MockStackOverflowCommunicator alloc] init];
    mgr.communicator = communicator;
}

- (void)tearDown {
    mgr = nil;
    delegate = nil;
    underlyingError = nil;
    questionArray = nil;
    questionBuilder = nil;
    communicator = nil;
    questionToFetch = nil;
    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate{
    XCTAssertThrows(mgr.delegate = (id<StackOverflowManagerDelegate>)[NSNull null],
                    @"NSNull should not be used as the delegate as doesn't "
                    @"conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate{
    id<StackOverflowManagerDelegate> delegate = [[MockStackOverflowManagerDelegate alloc] init];
    XCTAssertNoThrow(mgr.delegate = delegate,
                     @"Object conforming to the delegate protocol should be used "
                     @"as the delegate");
}

- (void)testManagerAcceptsNilAsADelegate{
    XCTAssertNoThrow(mgr.delegate = nil,
                     @"It should be acceptable to use nil as an object's delegate");
}

- (void)testAskingForQuestionsMeansRequestingData{
    MockStackOverflowCommunicator *communicator = [[MockStackOverflowCommunicator alloc] init];
    mgr.communicator = communicator;
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    [mgr fetchQuestionsOnTopic:topic];
    XCTAssertTrue([communicator wasAskedToFetchQuestions],
                  @"The communicator should need to fetch data");
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator{
    MockStackOverflowManagerDelegate *delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    NSError *underlyingError = [NSError errorWithDomain:kTestDomain
                                                   code:0 userInfo:nil];
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    XCTAssertFalse(underlyingError == [delegate fetchError],
                   @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError{
    MockStackOverflowManagerDelegate *delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    NSError *underlyingError = [NSError errorWithDomain:kTestDomain
                                                   code:0 userInfo:nil];
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    XCTAssertEqualObjects([[delegate fetchError] userInfo][NSUnderlyingErrorKey], underlyingError,
                          @"The underlying error should be available to client code");
}

- (void)testQuestionJSONIsPassedToQuestionBuilder {
    FakeQuestionBuilder *builder = [[FakeQuestionBuilder alloc] init];
    mgr.questionBuilder = builder;
    [mgr receivedQuestionsJSON:kFakeJSON];
    XCTAssertEqualObjects(builder.JSON, kFakeJSON,
                          @"Downloaded JSON is set to builder");
    mgr.questionBuilder = nil;
}

- (void)testDelegateNotifiedOfErrorWhenQuestionBuilderFails {
    FakeQuestionBuilder *builder = [[FakeQuestionBuilder alloc] init];
    builder.arrayToReturn = nil;
    builder.errorToSet = underlyingError;
    mgr.questionBuilder = builder;
    [mgr receivedQuestionsJSON:kFakeJSON];
    XCTAssertNotNil([[delegate fetchError] userInfo][NSUnderlyingErrorKey],
                    @"The delegate should have found out about the error");
    mgr.questionBuilder = nil;
}

- (void)testDelegateNotToldAboutErrorWhenQuestionsReceived{
    questionBuilder.arrayToReturn = questionArray;
    mgr.questionBuilder = questionBuilder;
    [mgr receivedQuestionsJSON:kFakeJSON];
    XCTAssertNil([delegate fetchError],
                 @"No error should be received on success");
}

- (void)testDelegateReceivesTheQuestionsDiscoveredByManager{
    questionBuilder.arrayToReturn = questionArray;
    mgr.questionBuilder = questionBuilder;
    [mgr receivedQuestionsJSON:kFakeJSON];
    XCTAssertEqualObjects([delegate receivedQuestions], questionArray,
                          @"The manager should have sent its questions"
                          @" to the delegate");
}

- (void)testEmptyArrayPassedToDelegate{
    questionBuilder.arrayToReturn = @[];
    mgr.questionBuilder = questionBuilder;
    [mgr receivedQuestionsJSON:kFakeJSON];
    XCTAssertEqualObjects([delegate receivedQuestions], @[],
                          @"Returning an empty array is not an error");
}

- (void)testAskingForQuestionBodyMeansRequestingData{
    [mgr fetchBodyForQuestion:questionToFetch];
    XCTAssertTrue([communicator wasAskedToFetchBody],
                  @"The communicator should need to retrieve data for the "
                  @"question body");
}

- (void)testDelegateNotifiedOfFailureToFetchQuestion {
    [mgr downloadInformationForQuestionFailedWithError:underlyingError];
    XCTAssertNotNil(delegate.fetchError.userInfo[NSUnderlyingErrorKey],
                    @"Delegate should have found out about this error");
}

- (void)testManagerPassesRetrievedQuestionBodyToQuestionBuilder {
    [mgr receivedQuestionBodyJSON:kFakeJSON];
    XCTAssertEqualObjects(questionBuilder.JSON, kFakeJSON,
                          @"Successfully-retrieved data should be passed to the builder");
}

- (void)testManagerPassesQuestionItWasSentToQuestionBuilderForFillingIn {
    [mgr fetchBodyForQuestion:questionToFetch];
    [mgr receivedQuestionBodyJSON:kFakeJSON];
    XCTAssertEqualObjects(questionBuilder.questionToFill, questionToFetch,
                          @"The question should have been passed to the builder");
}
@end
