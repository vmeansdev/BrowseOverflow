//
//  AnswersCreationWorkflowTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 31/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StackOverflowManager.h"
#import "MockStackOverflowCommunicator.h"
#import "MockStackOverflowManagerDelegate.h"
#import "Question.h"
#import "FakeAnswerBuilder.h"
#import "TestConsts.h"

@interface AnswersCreationWorkflowTests : XCTestCase

@end

@implementation AnswersCreationWorkflowTests{
    StackOverflowManager *mgr;
    MockStackOverflowCommunicator *communicator;
    MockStackOverflowManagerDelegate *delegate;
    Question *question;
    FakeAnswerBuilder *answerBuilder;
    NSError *error;
}

- (void)setUp {
    [super setUp];
    mgr = [[StackOverflowManager alloc] init];
    
    communicator = [[MockStackOverflowCommunicator alloc] initWithSession:nil];
    mgr.communicator = communicator;
    
    delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    
    question = [[Question alloc] init];
    question.questionID = 12345;
    
    answerBuilder = [[FakeAnswerBuilder alloc] init];
    mgr.answerBuilder = answerBuilder;
    
    error = [NSError errorWithDomain:kTestDomain code:42 userInfo:nil];
    
}

- (void)tearDown {
    mgr = nil;
    communicator = nil;
    delegate = nil;
    question = nil;
    answerBuilder = nil;
    error = nil;
    [super tearDown];
}

- (void)testAskingForAnswersMeansCommunicatingWithSite{
    [mgr fetchAnswersForQuestion:question];
    XCTAssertEqual(question.questionID, [communicator askedForAnswersToQuestionID],
                   @"Answers to questions are found by communicating with the web site");
}

- (void)testDelegateNotifiedOfFailureToGetAnswers{
    [mgr downloadAnswersToQuestionFailedWithError:error];
    XCTAssertEqualObjects(delegate.fetchError.userInfo[NSUnderlyingErrorKey], error,
                          @"Delegate should be notified of failure to communicate");
}

- (void)testManagerRememberWhichQuestionToAddAnswersTo{
    [mgr fetchAnswersForQuestion:question];
    XCTAssertEqualObjects(mgr.questionNeedingBody, question,
                          @"Manager should know to fill this question in");
}

- (void)testAnswerResponsePassedToAnswerBuilder{
    [mgr receivedAnswersJSON:kFakeJSON];
    XCTAssertEqualObjects(answerBuilder.receivedJSON, kFakeJSON,
                          @"Manager must pass response to builder to get answers constructed");
}

- (void)testQuestionPassedToAnswerBuilder{
    mgr.questionNeedingBody = question;
    [mgr receivedAnswersJSON:kFakeJSON];
    XCTAssertEqualObjects(answerBuilder.questionToFill, question,
                          @"Manager must pass the question into the answer builder");
}

- (void)testManagerNotifiesDelegateWhenAnswersAdded {
    answerBuilder.successful = YES;
    mgr.questionNeedingBody = question;
    [mgr receivedAnswersJSON:kFakeJSON];
    XCTAssertEqualObjects(delegate.bodyQuestion, question,
                          @"Manager should call the delegate method");
}

- (void)testManagerNotifiesDelegateWhenAnswersNotAdded{
    answerBuilder.successful = NO;
    answerBuilder.error = error;
    [mgr receivedAnswersJSON:kFakeJSON];
    XCTAssertEqualObjects(delegate.fetchError.userInfo[NSUnderlyingErrorKey], error,
                          @"Manager should pass an error on to the delegate");
}



































@end
