//
//  StackOverflowManager.m
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "StackOverflowManager.h"
#import "StackOverflowCommunicator.h"
#import "QuestionBuilder.h"
#import "AnswerBuilder.h"

#import "Topic.h"
#import "Question.h"

NSString *StackOverflowManagerError = @"StackOverflowManagerError";

@implementation StackOverflowManager
@synthesize delegate;

- (void)setDelegate:(id<StackOverflowManagerDelegate>)newDelegate{
    if (newDelegate && ![newDelegate conformsToProtocol:@protocol(StackOverflowManagerDelegate)]){
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Delegate object does not conform to the delegate protocol"
                               userInfo:nil] raise];
    }
    
    delegate = newDelegate;
}

#pragma mark - Questions
- (void)fetchQuestionsOnTopic:(Topic *)topic{
    [self.communicator searchForQuestionsWithTag:topic.tag];
}

- (void)searchingForQuestionsFailedWithError:(NSError *)error{
    [self tellDelegateAboutQuestionSearchError:error];
}

- (void)receivedQuestionsJSON:(NSString *)objectNotation{
    NSError *error;
    NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
    if (!questions){
        [self tellDelegateAboutQuestionSearchError:error];
    } else {
        [delegate didReceiveQuestions:questions];
    }
}

- (void)tellDelegateAboutQuestionSearchError:(NSError *)error{
    NSDictionary *errorInfo = [self errorInfoFor:error];
    
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorQuestionSearchCode
                                               userInfo:errorInfo];
    [delegate fetchingQuestionsFailedWithError:reportableError];
}

#pragma mark - Question body
- (void)fetchBodyForQuestion:(Question *)question{
    self.questionNeedingBody = question;
    [self.communicator downloadInformationForQuestionWithID:question.questionID];
}

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation{
    [self.questionBuilder fillInDetailsForQuestion:self.questionNeedingBody fromJSON:objectNotation];
    [delegate didReceiveBodyForQuestion: self.questionNeedingBody];
    self.questionNeedingBody = nil;
}

- (void)downloadInformationForQuestionFailedWithError:(NSError *)error {
    NSDictionary *errorInfo = [self errorInfoFor:error];
    
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorQuestionBodyFetchCode
                                               userInfo:errorInfo];
    [delegate downloadInformationForQuestionFailedWithError:reportableError];
}

#pragma mark - Answers

- (void)fetchAnswersForQuestion:(Question *)question{
    self.questionNeedingBody = question;
    [self.communicator downloadAnswersToQuestionWithID:question.questionID];
}

- (void)receivedAnswersJSON:(NSString *)objectNotation{
    NSError *error = nil;
    if ([self.answerBuilder addAnswersToQuestion: self.questionNeedingBody fromJSON: objectNotation error: &error]) {
        [delegate answersReceivedForQuestion: self.questionNeedingBody];
        self.questionNeedingBody = nil;
    }
    else {
        [self downloadAnswersToQuestionFailedWithError: error];
    }
}

- (void)downloadAnswersToQuestionFailedWithError:(NSError *)error{
    self.questionNeedingBody = nil;
    NSDictionary *userInfo = nil;
    if (error) {
        userInfo = @{NSUnderlyingErrorKey: error};
    }
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorAnswersFetchCode
                                               userInfo:userInfo];
    [delegate fetchingAnswersToQuestionFailedWithError:reportableError];
}

#pragma mark - Private
- (NSDictionary *)errorInfoFor:(NSError *)error{
    NSDictionary *errorInfo = nil;
    
    if (error){
        errorInfo = @{NSUnderlyingErrorKey: error};
    }
    
    return errorInfo;
}
@end
