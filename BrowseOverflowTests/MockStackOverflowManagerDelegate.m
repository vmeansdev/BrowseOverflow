//
//  MockStackOverflowManagerDeleagte.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 21/01/2018.
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

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error{
    self.fetchError = error;
}

- (void)didReceiveBodyForQuestion:(Question *)question{
    self.bodyQuestion = question;
}

@end
