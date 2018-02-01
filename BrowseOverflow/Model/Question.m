//
//  Question.m
//  BrowseOverflow
//
//  Created by vmeansdev on 16/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@implementation Question

- (instancetype)init{
    if (self = [super init]){
        answerSet = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (void)addAnswer:(Answer *)answer{
    [answerSet addObject:answer];
}


- (NSArray *)answers{
    return [[answerSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

@end
