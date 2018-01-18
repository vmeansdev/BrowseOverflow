//
//  Question.h
//  BrowseOverflow
//
//  Created by vmeansdev on 16/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Answer;
@interface Question : NSObject{
    NSMutableSet *answerSet;
}

@property (nonatomic) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger score;
@property (readonly) NSArray *answers;

- (void)addAnswer:(Answer *)answer;

@end
