//
//  Topic.h
//  BrowseOverflow
//
//  Created by vmeansdev on 16/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

@interface Topic : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *tag;

- (instancetype)initWithName:(NSString *)newName tag:(NSString *)tag;

- (NSArray *)recentQuestions;
- (void)addQuestion:(Question *)question;

@end
