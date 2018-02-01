//
//  AnswerBuilder.h
//  BrowseOverflow
//
//  Created by vmeansdev on 31/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *AnswerBuilderErrorDomain;

@class Question;

enum {
    AnswerBuilderInvalidJSONError,
    AnswerBuilderMissingDataError
};

@interface AnswerBuilder : NSObject

- (BOOL)addAnswersToQuestion:(Question *)question
                    fromJSON:(NSString *)objectNotation
                       error:(NSError **)error;

@end
