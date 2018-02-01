//
//  StackOverflowCommunicatorTests.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 21/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InspectableStackOverflowCommunicator.h"
#import "NSURLSessionMock.h"
#import "NSURLSessionDataTaskMock.h"
#import "FakeURLResponse.h"
#import "TestConsts.h"

static NSString *const kTestString = @"Test string";
static NSString *const kIosTag = @"ios";

@interface StackOverflowCommunicatorTests : XCTestCase

@end

@implementation StackOverflowCommunicatorTests{
    InspectableStackOverflowCommunicator *communicator;
    NSURLSessionMock *session;
}

- (void)setUp {
    [super setUp];
    FakeURLResponse *successResponse = [[FakeURLResponse alloc] initWithStatusCode:200];
    
    session = [[NSURLSessionMock alloc] init];
    session.response = (NSHTTPURLResponse *)successResponse;
    
    communicator = [[InspectableStackOverflowCommunicator alloc] initWithSession:session];
    
}

- (void)tearDown {
    communicator = nil;
    session = nil;
    [super tearDown];
}

- (void)testSearchingForQuestionsOnTopicCallsTopicAPI {
    [communicator searchForQuestionsWithTag:@"ios"];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString],
                          @"http://api.stackoverflow.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=ios&site=stackoverflow",
                          @"Use the search API to find questions with a particular tag");
}

- (void)testFillingInQuestionBodyCallsQuestionAPI{
    [communicator downloadInformationForQuestionWithID:12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString],
                          @"http://api.stackoverflow.com/2.2/questions/12345?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wwYGT",
                          @"Use the question API to get the body for a question");
}

- (void)testFetchingAnswersToQuestionCallsQuestionAPI {
    [communicator downloadAnswersToQuestionWithID:12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString],
                          @"http://api.stackoverflow.com/2.2/questions/12345/"
                          @"answers?order=desc&sort=activity"
                          @"&site=stackoverflow&filter=!9Z(-wzu0T",
                          @"Use the question API to get answers on a given question");
}

- (NSData *)dataWithString:(NSString *)string{
    const char *utfString = [string UTF8String];
    NSData *data = [NSData dataWithBytes:utfString length:strlen(utfString)];
    return data;
}

- (void)testDataIsCorrectWhenResponseIsSuccessful {

    NSData *data = [self dataWithString:kTestString];
    session.data = data;
    
    [communicator searchForQuestionsWithTag:kIosTag];
    
    XCTAssertEqualObjects([communicator responseData], data,
                          @"Data should be the same");
}

- (void)testDataIsNilWhenNetworkErrorOccurred {
    NSError *error = [NSError errorWithDomain:kTestDomain
                                         code:0 userInfo:nil];
    session.error = error;
    [communicator searchForQuestionsWithTag:kIosTag];
    XCTAssertEqualObjects([[communicator responseError] userInfo][NSUnderlyingErrorKey],
                          error,
                          @"Communicator should store response error");
    XCTAssertNil([communicator responseData],
                 @"Response data should be nil when networking error occurred");
}

- (void)testErrorIsNotNilWhenResponseStatusCodeIsNotEqualToTwoHundred {
    FakeURLResponse *unsuccessfulResponse = [[FakeURLResponse alloc] initWithStatusCode:400];
    
    session.response = (NSHTTPURLResponse *)unsuccessfulResponse;
    
    [communicator searchForQuestionsWithTag:kIosTag];
    XCTAssertNotNil([communicator responseError],
                    @"Response error should not be nil when response has unsuccessful status code");
}

@end
