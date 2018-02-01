//
//  StackOverflowCommunicatorDelegate.h
//  BrowseOverflow
//
//  Created by vmeansdev on 22/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StackOverflowCommunicatorDelegate <NSObject>

- (void)searchingForQuestionsFailedWithError:(NSError *)error;

- (void)downloadInformationForQuestionFailedWithError:(NSError *)error;

- (void)downloadAnswersToQuestionFailedWithError:(NSError *)error;

- (void)receivedQuestionsJSON:(NSString *)objectNotation;

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation;

- (void)receivedAnswersJSON:(NSString *)objectNotation;

@end
