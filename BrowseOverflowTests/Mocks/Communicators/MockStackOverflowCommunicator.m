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
}

- (void)searchForQuestionsWithTag:(NSString *)tag{
    wasAskedToFetchQuestions = YES;
}

- (void)searchForQuestionWithID:(NSInteger)questionID{
    wasAskedToFetchBody = YES;
}

- (BOOL)wasAskedToFetchQuestions{
    return wasAskedToFetchQuestions;
}

- (BOOL)wasAskedToFetchBody{
    return wasAskedToFetchBody;
}

@end
