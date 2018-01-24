//
//  NSURLSessionMock.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 22/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "NSURLSessionMock.h"
#import "NSURLSessionDataTaskMock.h"

@implementation NSURLSessionMock

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData * _Nullable _data,
                                                        NSURLResponse * _Nullable _response,
                                                        NSError * _Nullable _error))completionHandler{
    __weak typeof (self) w_self = self;
    NSURLSessionDataTaskMock *dataTask = [[NSURLSessionDataTaskMock alloc] initWithClosure:^{
        __strong typeof (self) sself = w_self;
        completionHandler(sself.data, sself.response, sself.error);
    }];
    return dataTask;
}

@end
