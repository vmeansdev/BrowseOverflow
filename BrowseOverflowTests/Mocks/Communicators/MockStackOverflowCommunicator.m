//
//  MockStackOverflowCommunicator.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "MockStackOverflowCommunicator.h"

@implementation MockStackOverflowCommunicator{
    BOOL wasAskedToFetchQuestions;
    BOOL wasAskedToFetchBody;
    NSInteger _questionID;
}

- (instancetype)init {
    if ((self = [super init])) {
        _questionID = NSNotFound;
    }
    return self;
}

- (void)searchForQuestionsWithTag:(NSString *)tag{
    wasAskedToFetchQuestions = YES;
}

- (void)downloadInformationForQuestionWithID:(NSInteger)questionID{
    wasAskedToFetchBody = YES;
}

- (BOOL)wasAskedToFetchQuestions{
    return wasAskedToFetchQuestions;
}

- (BOOL)wasAskedToFetchBody{
    return wasAskedToFetchBody;
}

- (void)downloadAnswersToQuestionWithID:(NSInteger)questionID{
    _questionID = questionID;
}

- (NSInteger)askedForAnswersToQuestionID{
    return _questionID;
}

@end
