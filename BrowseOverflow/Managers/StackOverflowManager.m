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
    [self.communicator searchForQuestionWithID:question.questionID];
}

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation{
    [self.questionBuilder fillInDetailsForQuestion:self.questionNeedingBody fromJSON:objectNotation];
    [delegate didReceiveBodyForQuestion: self.questionNeedingBody];
    self.questionNeedingBody = nil;
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error{
    NSDictionary *errorInfo = [self errorInfoFor:error];
    
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerError
                                                   code:StackOverflowManagerErrorQuestionBodyFetchCode
                                               userInfo:errorInfo];
    [delegate fetchingQuestionBodyFailedWithError:reportableError];
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
