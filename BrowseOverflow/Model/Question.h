//
//  Question.h
//  BrowseOverflow
//
//  Created by vmeansdev on 16/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Answer;
@class Person;
@interface Question : NSObject{
    NSMutableSet *answerSet;
}

@property (nonatomic) NSInteger questionID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSInteger score;
@property (nonatomic) Person *asker;
@property (readonly) NSArray *answers;

- (void)addAnswer:(Answer *)answer;

@end
