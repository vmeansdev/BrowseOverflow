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
}

- (void)searchForQuestionsWithTag:(NSString *)tag{
    wasAskedToFetchQuestions = YES;
}

- (BOOL)wasAskedToFetchQuestions{
    return wasAskedToFetchQuestions;
}

@end
