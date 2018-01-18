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

NSString *StackOverflowManagerError = @"StackOverflowManagerError";
NSString *StackOverflowManagerSearchFailedError = @"StackOverflowManagerSearchFailedError";

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
    NSDictionary *errorInfo = nil;
    
    if (error){
        errorInfo = @{NSUnderlyingErrorKey: error};
    }
    
    NSError *reportableError = [NSError errorWithDomain:StackOverflowManagerSearchFailedError
                                                   code:StackOverflowManagerErrorQuestionSearchCode
                                               userInfo:errorInfo];
    [delegate fetchingQuestionsFailedWithError:reportableError];
}

@end
