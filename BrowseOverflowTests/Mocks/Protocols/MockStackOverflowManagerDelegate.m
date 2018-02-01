//
//  MockStackOverflowManagerDelegate.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "MockStackOverflowManagerDelegate.h"

@implementation MockStackOverflowManagerDelegate

- (void)fetchingQuestionsFailedWithError:(NSError *)error{
    self.fetchError = error;
}

- (void)didReceiveQuestions:(NSArray *)questions{
    self.receivedQuestions = questions;
}

@end
