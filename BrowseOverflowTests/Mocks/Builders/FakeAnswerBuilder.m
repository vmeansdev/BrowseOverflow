//
//  FakeAnswerBuilder.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 01/02/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "FakeAnswerBuilder.h"

@implementation FakeAnswerBuilder

- (BOOL)addAnswersToQuestion: (Question *)question fromJSON: (NSString *)objectNotation error: (NSError **)addError {
    self.questionToFill = question;
    self.receivedJSON = objectNotation;
    if (addError) {
        *addError = self.error;
    }
    return self.successful;
}

@end
