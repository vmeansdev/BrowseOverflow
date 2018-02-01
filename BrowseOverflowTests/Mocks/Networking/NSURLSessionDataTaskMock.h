//
//  NSURLSessionDataTaskMock.h
//  BrowseOverflowTests
//
//  Created by vmeansdev on 21/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Completion)(void);

@interface NSURLSessionDataTaskMock : NSURLSessionDataTask

@property (nonatomic) Completion closure;

- (instancetype)initWithClosure:(Completion)closure;

@end
