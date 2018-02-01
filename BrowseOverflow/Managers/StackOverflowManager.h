//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"
#import "StackOverflowCommunicatorDelegate.h"

@class Topic;
@class StackOverflowCommunicator;
@class QuestionBuilder;
@class Question;
@class AnswerBuilder;

extern NSString *StackOverflowManagerError;

enum {
    StackOverflowManagerErrorQuestionSearchCode,
    StackOverflowManagerErrorQuestionBodyFetchCode,
    StackOverflowManagerErrorAnswersFetchCode
};


@interface StackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>

@property (weak, nonatomic) id <StackOverflowManagerDelegate> delegate;

@property (strong) StackOverflowCommunicator *communicator;

@property (strong) QuestionBuilder *questionBuilder;

@property (strong) AnswerBuilder *answerBuilder;

@property (nonatomic) Question *questionNeedingBody;

/** Questions **/
- (void)receivedQuestionsJSON:(NSString *)objectNotation;

- (void)fetchQuestionsOnTopic:(Topic *)topic;

- (void)searchingForQuestionsFailedWithError:(NSError *)error;

/** Qusetion body **/
- (void)fetchBodyForQuestion:(Question *)question;

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation;

- (void)downloadInformationForQuestionFailedWithError:(NSError *)error;

/** Answers **/
- (void)fetchAnswersForQuestion:(Question *)question;

- (void)receivedAnswersJSON:(NSString *)objectNotation;

- (void)downloadAnswersToQuestionFailedWithError:(NSError *)error;

@end
