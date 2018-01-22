//
//  MockStackOverflowManagerDeleagte.h
//  BrowseOverflowTests
//
//  Created by vmeansdev on 21/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackOverflowManagerDelegate.h"

@class Question;

@interface MockStackOverflowManagerDelegate : NSObject <StackOverflowManagerDelegate>

@property (nonatomic) NSError *fetchError;

@property (nonatomic) NSArray *receivedQuestions;

@property (nonatomic) Question *bodyQuestion;

@end
