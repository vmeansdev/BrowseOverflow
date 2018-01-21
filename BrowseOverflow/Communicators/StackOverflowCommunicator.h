//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowCommunicator : NSObject

- (void)searchForQuestionsWithTag:(NSString *)tag;

- (void)searchForQuestionWithID:(NSInteger)questionID;

@end
