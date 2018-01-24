//
//  InspectableStackOverflowCommunicator.m
//  BrowseOverflowTests
//
//  Created by vmeansdev on 21/01/2018.
//  Copyright © 2018 vmeansdev. All rights reserved.
//

#import "InspectableStackOverflowCommunicator.h"

@implementation InspectableStackOverflowCommunicator

- (NSURL *)URLToFetch{
    return fetchingURL;
}

- (NSData *)responseData{
    return rawResponseData;
}

- (NSError *)responseError{
    return responseError;
}

@end
