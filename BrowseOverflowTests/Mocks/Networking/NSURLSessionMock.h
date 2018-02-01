//
//  NSURLSessionMock.h
//  BrowseOverflowTests
//
//  Created by vmeansdev on 22/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

@interface NSURLSessionMock : NSURLSession

@property (nonatomic) NSData *data;
@property (nonatomic) NSHTTPURLResponse *response;
@property (nonatomic) NSError *error;

@end
