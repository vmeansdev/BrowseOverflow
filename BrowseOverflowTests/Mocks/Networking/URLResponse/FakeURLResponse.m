//
//  FakeURLResponse.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 22/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "FakeURLResponse.h"

@implementation FakeURLResponse{
    NSInteger _code;
}

- (instancetype)initWithStatusCode:(NSInteger)statusCode{
    if (self = [super init]){
        _code = statusCode;
    }
    
    return self;
}


- (NSInteger)statusCode{
    return _code;
}

@end
