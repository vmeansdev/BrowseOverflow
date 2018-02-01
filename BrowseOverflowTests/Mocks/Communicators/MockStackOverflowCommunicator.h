//
//  MockStackOverflowCommunicator.h
//  BrowseOverflowTests
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicator.h"

@interface MockStackOverflowCommunicator : StackOverflowCommunicator

- (BOOL)wasAskedToFetchQuestions;

- (BOOL)wasAskedToFetchBody;

- (NSInteger)askedForAnswersToQuestionID;

@end
