//
//  FakeAnswerBuilder.h
//  BrowseOverflowTests
//
//  Created by vmeansdev on 01/02/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "AnswerBuilder.h"

@class Question;

@interface FakeAnswerBuilder : AnswerBuilder

@property (retain) NSString *receivedJSON;
@property (retain) Question *questionToFill;
@property (retain) NSError *error;
@property BOOL successful;

@end
