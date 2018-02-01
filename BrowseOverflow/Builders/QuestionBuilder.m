//
//  QuestionBuilder.m
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "QuestionBuilder.h"
#import "Question.h"
#import "Person.h"

NSString *const kQuestionsKey = @"items";
NSString *const kTitleKey = @"title";
NSString *const kBodyKey = @"body";
NSString *const kQuestionIdKey = @"question_id";
NSString *const kCreationDateKey = @"creation_date";
NSString *const kScoreKey = @"score";

NSString *const kOwnerKey = @"owner";
NSString *const kAvatarKey = @"profile_image";
NSString *const kNameKey = @"display_name";

NSString *QuestionBuilderErrorDomain = @"QuestionBuilderErrorDomain";

@implementation QuestionBuilder

- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error{
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:&localError];
    NSDictionary *parsedObject = (NSDictionary *)jsonObject;
    
    if (!parsedObject){
        if (error != NULL){
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain
                                         code:QuestionBuilderInvalidJSONError userInfo:nil];
        }
        
        return nil;
    }
    
    NSArray *questions = parsedObject[kQuestionsKey];
    if (!questions){
        if (error != NULL){
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain
                                         code:QuestionBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[questions count]];
    for (NSDictionary *parsedObject in questions){
        Question *q = [[Question alloc] init];
        q.title = parsedObject[kTitleKey];
        q.questionID = [parsedObject[kQuestionIdKey] integerValue];
        q.date = [NSDate dateWithTimeIntervalSince1970:[parsedObject[kCreationDateKey] doubleValue]];
        q.score = [parsedObject[kScoreKey] integerValue];
        
        NSDictionary *od = parsedObject[kOwnerKey];
        NSString *aName = od[kNameKey];
        NSString *aAvatarURL = od[kAvatarKey];
        Person *asker = [[Person alloc] initWithName:aName avatarLocation:aAvatarURL];
        q.asker = asker;
        
        [results addObject:q];
    }
    
    
    return [results copy];
}

- (void)fillInDetailsForQuestion:(Question *)question fromJSON:(NSString *)objectNotation{
    NSParameterAssert(objectNotation != nil);
    NSParameterAssert(question != nil);
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parsedDict = [NSJSONSerialization JSONObjectWithData:unicodeNotation options:0 error:NULL];
    if (!parsedDict){
        return;
    }
    
    NSString *body = [parsedDict[kQuestionsKey] lastObject][kBodyKey];
    if (body){
        question.body = [body copy];
    }
}

@end
