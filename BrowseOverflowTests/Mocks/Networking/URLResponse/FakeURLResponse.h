//
//  FakeURLResponse.h
//  BrowseOverflowTests
//
//  Created by vmeansdev on 22/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeURLResponse : NSURLResponse

@property (readonly) NSInteger statusCode;

- (instancetype)initWithStatusCode:(NSInteger)statusCode;

@end
