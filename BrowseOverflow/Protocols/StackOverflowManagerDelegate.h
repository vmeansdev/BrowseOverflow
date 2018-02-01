//
//  StackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Topic;
@class Question;

@protocol StackOverflowManagerDelegate <NSObject>

- (void)fetchingQuestionsFailedWithError:(NSError *)error;

- (void)downloadInformationForQuestionFailedWithError:(NSError *)error;

- (void)fetchingAnswersToQuestionFailedWithError:(NSError *)error;

- (void)didReceiveQuestions:(NSArray *)questions;

- (void)didReceiveBodyForQuestion:(Question *)question;

- (void)answersReceivedForQuestion:(Question *)question;

@end
