//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"

@class Topic;
@class StackOverflowCommunicator;
@class QuestionBuilder;

extern NSString *StackOverflowManagerError;
extern NSString *StackOverflowManagerSearchFailedError;

enum {
    StackOverflowManagerErrorQuestionSearchCode
};


@interface StackOverflowManager : NSObject

@property (weak, nonatomic) id <StackOverflowManagerDelegate> delegate;

@property (strong) StackOverflowCommunicator *communicator;

@property (strong) QuestionBuilder *questionBuilder;

- (void)receivedQuestionsJSON:(NSString *)objectNotation;

- (void)fetchQuestionsOnTopic:(Topic *)topic;

- (void)searchingForQuestionsFailedWithError:(NSError *)error;

@end
