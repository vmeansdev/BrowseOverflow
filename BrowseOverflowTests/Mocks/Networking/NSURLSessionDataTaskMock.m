//
//  NSURLSessionDataTaskMock.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 21/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "NSURLSessionDataTaskMock.h"

@implementation NSURLSessionDataTaskMock

- (instancetype)initWithClosure:(Completion)closure{
    if (self = [super init]){
        self.closure = closure;
    }
    
    return self;
}

- (void)resume{
    self.closure();
}


@end
