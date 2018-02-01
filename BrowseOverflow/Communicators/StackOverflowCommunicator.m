//
//  StackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by vmeansdev on 18/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "StackOverflowCommunicator.h"

NSString *StackOverflowCommunicatorErrorDomain = @"StackOverflowCommunicatorErrorDomain";
NSString *const kBaseURL = @"http://api.stackoverflow.com";

@implementation StackOverflowCommunicator{
    NSURLSession *_session;
    NSURLSessionDataTask *_task;
}

- (instancetype)initWithSession:(NSURLSession *)session{
    if (self = [super init]){
        _session = session;
    }
    
    return self;
}

- (void)fetchContentAtURL:(NSURL *)url completion:(void (^)(NSString *objectNotation, NSError *error))completion{
    fetchingURL = url;
    
    rawResponseData = nil;
    responseError = nil;
    
    if (_task && (_task.state == NSURLSessionTaskStateRunning)){
        [_task cancel];
        _task = nil;
    }
    
    NSTimeInterval timeout = 10.0;
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:timeout];
    _task = [self.session dataTaskWithRequest:request
                            completionHandler:^(NSData * _Nullable data,
                                                NSURLResponse * _Nullable response,
                                                NSError * _Nullable error) {
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                if (error){
                                    NSError *_error = [NSError errorWithDomain:StackOverflowCommunicatorErrorDomain
                                                                          code:StackOverflowCommunicatorErrorCode
                                                                      userInfo:@{NSUnderlyingErrorKey: error}];
                                    responseError = _error;
                                    completion(nil, _error);
                                }
                                
                                if (httpResponse.statusCode != 200){
                                    NSError *_error = [NSError errorWithDomain:StackOverflowCommunicatorErrorDomain
                                                                          code:httpResponse.statusCode userInfo:nil];
                                    responseError = _error;
                                    completion(nil, _error);
                                } else {
                                    rawResponseData = data;
                                    NSString *notation = [[NSString alloc] initWithData:data
                                                                               encoding:NSUTF8StringEncoding];
                                    completion(notation, nil);
                                }
    }];
    
    [_task resume];
}


- (void)searchForQuestionsWithTag:(NSString *)tag{
    NSString *completeURL = [NSString stringWithFormat:@"%@/2.2/search?pagesize=20&order=desc&sort=activity&tagged=%@&site=stackoverflow", kBaseURL, tag];
    NSURL *url = [NSURL URLWithString:completeURL];
    [self fetchContentAtURL:url completion:^(NSString *objectNotation, NSError *error) {
        if (error){
            [self.delegate searchingForQuestionsFailedWithError:error];
        } else {
            [self.delegate receivedQuestionsJSON:objectNotation];
        }
    }];
}

- (void)downloadInformationForQuestionWithID:(NSInteger)questionID{
    NSString *completeURL = [NSString stringWithFormat:@"%@/2.2/questions/%ld?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wwYGT", kBaseURL, questionID];
    NSURL *url = [NSURL URLWithString:completeURL];
    [self fetchContentAtURL:url completion:^(NSString *objectNotation, NSError *error) {
        if (error){
            [self.delegate downloadInformationForQuestionFailedWithError:error];
        } else {
            [self.delegate receivedQuestionBodyJSON:objectNotation];
        }
    }];
}

- (void)downloadAnswersToQuestionWithID:(NSInteger)questionID{
    NSString *completeURL = [NSString stringWithFormat:@"%@/2.2/questions/%ld/answers?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wzu0T", kBaseURL, questionID];
    NSURL *url = [NSURL URLWithString:completeURL];
    [self fetchContentAtURL:url completion:^(NSString *objectNotation, NSError *error) {
        if (error){
            [self.delegate downloadAnswersToQuestionFailedWithError:error];
        } else {
            [self.delegate receivedAnswersJSON:objectNotation];
        }
    }];
}

- (void)dealloc{
//    if (_session){
//        [_session invalidateAndCancel];
//    }
}

#pragma mark - Private
- (NSURLSession *)session{
    if (!_session){
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return _session;
}

@end
