//
//  InspectableStackOverflowCommunicator.h
//  BrowseOverflowTests
//
//  Created by vmeansdev on 21/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@interface InspectableStackOverflowCommunicator : StackOverflowCommunicator

- (NSURL *)URLToFetch;

- (NSData *)responseData;

- (NSError *)responseError;

@end
