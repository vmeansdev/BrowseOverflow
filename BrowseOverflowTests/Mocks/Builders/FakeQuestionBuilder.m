//
//  FakeQuestionBuilder.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "FakeQuestionBuilder.h"

@implementation FakeQuestionBuilder

- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error{
    *error = self.errorToSet;
    self.JSON = [objectNotation copy];
    return self.arrayToReturn;
}

@end
