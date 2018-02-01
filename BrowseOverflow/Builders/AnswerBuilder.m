//
//  AnswerBuilder.m
//  BrowseOverflow
//
//  Created by vmeansdev on 31/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "AnswerBuilder.h"
#import "Question.h"
#import "Answer.h"

NSString *const kAnswersKey = @"items";

NSString *AnswerBuilderErrorDomain = @"AnswerBuilderErrorDomain";

@implementation AnswerBuilder

- (BOOL)addAnswersToQuestion:(Question *)question fromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error{
    NSParameterAssert(question != nil);
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:&localError];
    NSDictionary *parsedObject = (NSDictionary *)jsonObject;
    
    if (!parsedObject){
        if (error != NULL){
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain
                                         code:AnswerBuilderInvalidJSONError userInfo:nil];
        }
        
        return NO;
    }
    
    NSArray *answers = parsedObject[kAnswersKey];
    if (!answers){
        if (error != NULL){
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain
                                         code:AnswerBuilderMissingDataError userInfo:nil];
        }
        return NO;
    }

    for (NSDictionary *parsedObject in answers){
        Answer *answer = [[Answer alloc] init];
        answer.accepted = [parsedObject[@"is_accepted"] boolValue];
        answer.score = [parsedObject[@"score"] integerValue];
        answer.text = parsedObject[@"body"];
        
        
        NSDictionary *od = parsedObject[@"owner"];
        NSString *aName = od[@"display_name"];
        NSString *aAvatarURL = od[@"profile_image"];
        Person *answerer = [[Person alloc] initWithName:aName avatarLocation:aAvatarURL];
        answer.person = answerer;
        
        [question addAnswer:answer];
    }
    
    return YES;
}

@end
