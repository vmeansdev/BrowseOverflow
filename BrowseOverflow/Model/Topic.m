//
//  Topic.m
//  BrowseOverflow
//
//  Created by vmeansdev on 16/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "Topic.h"
#import "Question.h"

@interface Topic()

@property (readwrite) NSString *name;
@property (readwrite) NSString *tag;

@end

@implementation Topic{
    NSArray *questions;
}

- (instancetype)initWithName:(NSString *)newName tag:(NSString *)tag{
    if (self = [super init]){
        self.name = [newName copy];
        self.tag = [tag copy];
        questions = [[NSArray alloc] init];
    }
    
    return self;
}

- (NSArray *)sortQuestionsLatestFirst:(NSArray *)questionList{
    return [questionList sortedArrayUsingComparator:^NSComparisonResult(Question *q1, Question *q2) {
        return [q2.date compare:q1.date];
    }];
}

- (NSArray *)recentQuestions{
    return [self sortQuestionsLatestFirst:questions];
}

- (void)addQuestion:(Question *)question{
    NSArray *newQuestions = [questions arrayByAddingObject:question];
    if ([newQuestions count] > 20){
        newQuestions = [self sortQuestionsLatestFirst:newQuestions];
        newQuestions = [newQuestions subarrayWithRange:NSMakeRange(0, 20)];
    }
    
    questions = newQuestions;
}

@end
