//
//  StackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Topic;

@protocol StackOverflowManagerDelegate <NSObject>

- (void)fetchingQuestionsFailedWithError:(NSError *)error;

- (void)didReceiveQuestions:(NSArray *)questions;

@end
