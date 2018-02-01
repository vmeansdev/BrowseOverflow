//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"

typedef void (^FetchCompletion)(NSString *, NSError *);


extern NSString *StackOverflowCommunicatorErrorDomain;

enum {
    StackOverflowCommunicatorErrorCode
};

@interface StackOverflowCommunicator : NSObject{
    @protected
    NSURL *fetchingURL;
    NSData *rawResponseData;
    NSError *responseError;
}

@property (nonatomic, weak) id <StackOverflowCommunicatorDelegate> delegate;

- (instancetype)initWithSession:(NSURLSession *)session;

- (void)fetchContentAtURL:(NSURL *)url completion:(FetchCompletion)completion;

- (void)searchForQuestionsWithTag:(NSString *)tag;

- (void)downloadInformationForQuestionWithID:(NSInteger)questionID;

- (void)downloadAnswersToQuestionWithID:(NSInteger)questionID;

@end
